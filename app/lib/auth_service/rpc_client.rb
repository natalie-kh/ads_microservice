# frozen_string_literal: true

require_relative 'rpc_api'

module AuthService
  class RpcClient
    extend Dry::Initializer[undefined: false]
    include RpcApi

    option :queue, default: proc { create_queue }
    option :reply_queue, default: proc { create_reply_queue }
    option :lock, default: proc { Mutex.new }
    option :condition, default: proc { ConditionVariable.new }

    attr_reader :user_id

    def self.fetch
      Thread.current['auth_service.rpc_client'] ||= new.start
    end

    def start
      @reply_queue.subscribe do |_delivery_info, properties, payload|
        if properties[:correlation_id] == @correlation_id
          @user_id = JSON(payload)['user_id']

          @lock.synchronize { @condition.signal }
        end
      end

      self
    end

    private

    attr_writer :correlation_id

    def create_queue
      channel = RabbitMq.channel
      channel.queue('auth', durable: true)
    end

    def create_reply_queue
      channel = RabbitMq.channel
      channel.queue('amq.rabbitmq.reply-to')
    end

    def publish(payload, opts = {})
      @lock.synchronize do
        self.correlation_id = SecureRandom.uuid

        @queue.publish(
          payload,
          opts.merge(
            app_id: 'ads',
            reply_to: @reply_queue.name,
            correlation_id: @correlation_id,
            headers: {
              request_id: Thread.current[:request_id]
            }
          )
        )

        @condition.wait(@lock)
      end
    end
  end
end

# frozen_string_literal: true

require 'json'

module AuthService
  module Api
    def auth(token)
      response = connection.post('auth') do |request|
        request.headers['Authorization'] = "Bearer #{token}"
        request.headers['X-Request-Id'] = Thread.current[:request_id]
      end

      response.body.dig('meta', 'user_id') if response.success?
    end
  end
end

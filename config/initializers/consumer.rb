# frozen_string_literal: true

channel = RabbitMq.consumer_channel
exchange = channel.default_exchange
queue = channel.queue('ads', durable: true)

queue.subscribe(manual_ack: true) do |delivery_info, properties, payload|
  Thread.current[:request_id] = properties.headers['request_id']

  payload = JSON(payload)
  lat, lon = payload['coordinates']
  Ads::UpdateService.call(payload['id'], lat: lat, lon: lon)

  Application.logger.info(
    'geocode coordinates',
    id: payload['id'],
    coordinates: payload['coordinates']
  )

  exchange.publish(
    '',
    routing_key: properties.reply_to,
    correlation_id: properties.correlation_id,
    headers: {
      request_id: properties.headers['request_id']
    }
  )

  channel.ack(delivery_info.delivery_tag)
end

# frozen_string_literal: true

module AuthService
  module RpcApi
    def auth(token)
      payload = { token: token }.to_json
      publish(payload, type: 'auth')
    end
  end
end

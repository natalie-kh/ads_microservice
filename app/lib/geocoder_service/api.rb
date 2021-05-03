# frozen_string_literal: true

require 'json'

module GeocoderService
  module Api
    def geocode(city)
      response = connection.get('geocode') do |request|
        request.params['city'] = city
      end

      response.body if response.success? && response.body.present?
    end
  end
end

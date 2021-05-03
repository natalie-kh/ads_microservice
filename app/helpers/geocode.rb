# frozen_string_literal: true

module Geocode
  def coordinates
    geocoder_service.geocode(request.params['ad']['city'])
  end

  private

  def geocoder_service
    @geocoder_service ||= GeocoderService::Client.new
  end
end

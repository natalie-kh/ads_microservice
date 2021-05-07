# frozen_string_literal: true

module Ads
  class UpdateService
    prepend BasicService

    option :id
    option :data
    option :ad, default: proc { Ad.first(id: @id) }

    attr_reader :ad

    def call
      return fail!(I18n.t(:not_found, scope: 'services.ads.update_service')) if @ad.blank?

      @ad.update_fields(@data, %i[lat lon])
    end
  end
end

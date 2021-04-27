# frozen_string_literal: true

require 'sinatra'
require 'sinatra/namespace'
require 'sinatra/activerecord'
require 'will_paginate'
require 'will_paginate/active_record'
require 'pry'

Dir['./app/**/*.rb'].sort.each { |f| require f }

class App < Sinatra::Base
  register Sinatra::Namespace

  before do
    content_type 'application/json'
  end

  namespace '/api/v1' do
    get '/ads' do
      ads = Ad.paginate(page: params[:page], per_page: 10).order(updated_at: :desc)

      [200, AdSerializer.new(ads).serialized_json]
    end

    post '/ads' do
      halt 403 unless request.env['HTTP_AUTHORIZATION']

      result = AdValidator.new.call(json_params['ad'])

      if result.success?
        GeocodingService.call(result)
        [201, AdSerializer.new(Ad.create!(result.to_h)).serialized_json]
      else
        [422, result.errors.to_h.to_json]
      end
    end
  end

  helpers do
    def json_params
      JSON.parse(request.body.read)
    rescue StandardError
      halt 400, { message: 'Invalid JSON' }.to_json
    end
  end
end

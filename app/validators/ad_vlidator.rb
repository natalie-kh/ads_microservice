# frozen_string_literal: true

require 'dry/validation'

class AdValidator < Dry::Validation::Contract
  params do
    required(:title).filled(:string)
    required(:description).filled(:string)
    required(:city).filled(:string)
    required(:user_id).value(:integer)
  end
end

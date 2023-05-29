# frozen_string_literal: true

require 'faker'
FactoryBot.define do
  factory :post do
    user_id { SecureRandom.uuid }
    insights { '' }
  end
end

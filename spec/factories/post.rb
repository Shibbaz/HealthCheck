# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :post do
    user_id { SecureRandom.uuid }
    text { Faker::Markdown.emphasis }
    id { SecureRandom.uuid }
    likes { [] }
  end
end

# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :comment do
    user_id { SecureRandom.uuid }
    text { Faker::Markdown.emphasis }
    likes { [] }
  end
end

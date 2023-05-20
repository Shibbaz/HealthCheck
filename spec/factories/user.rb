require "faker"
FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password_digest { Faker::Internet.password }
    id { SecureRandom.uuid }
    archive { false }
    points { 0 }
    phone_number { 667089810 }
  end
end

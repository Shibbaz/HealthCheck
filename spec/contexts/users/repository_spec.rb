require "rails_helper"
require "faker"

RSpec.describe Contexts::Users::Repository, type: :model do
  context "create method" do
    it "it success" do
      auth_provider = {
        credentials: {
          email: Faker::Internet.email,
          password: "12345678910"
        }
      }
      event_store = Contexts::Users::Repository.new.create_user(auth_provider: auth_provider, name: Faker::Name.name, phone_number: 667089810, gender: 0)
      expect(event_store).to have_published(an_event(UserWasCreated))
    end
  end
end

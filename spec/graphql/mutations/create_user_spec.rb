require "rails_helper"

RSpec.describe Mutations::CreateUserMutation, type: :request do
  let(:email) {
    Faker::Internet.email
  }

  let(:auth_provider) {
    {
      credentials: {
        email: email,
        password: "[omitted]"
      }
    }
  }

  describe ".mutation passes" do
    it "create new user" do
      user = Mutations::CreateUserMutation.new(object: nil, field: nil, context: {}).resolve(
        name: "Test User",
        phone_number: 667089810,
        auth_provider: auth_provider,
        gender: 0
      )
      assert user.persisted?
      assert_equal user.name, "Test User"
      assert_equal user.email, email
    end
  end
end

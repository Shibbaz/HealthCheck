# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Users::CreateMutation, type: :request do
  let(:email) do
    Faker::Internet.email
  end

  let(:auth_provider) do
    {
      credentials: {
        email:,
        password: '[omitted]'
      }
    }
  end

  describe '.mutation passes' do
    it 'create new user' do
      user = Mutations::Users::CreateMutation.new(object: nil, field: nil, context: {}).resolve(
        name: 'Test User',
        phone_number: 667_089_810,
        auth_provider:,
        gender: 0
      )
      assert user.persisted?
      assert_equal user.name, 'Test User'
      assert_equal user.email, email
    end
  end
end

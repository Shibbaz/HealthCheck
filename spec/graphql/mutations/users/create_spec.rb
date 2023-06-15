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

  describe 'Mutation Success' do
    it 'expects to create user successfully' do
      user = Mutations::Users::CreateMutation.new(object: nil, field: nil, context: {ip: Faker::Internet.ip_v4_address}).resolve(
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

  describe 'Mutation Failure' do
    it 'expects to not create user' do
      user = Mutations::Users::CreateMutation.new(object: nil, field: nil, context: {
        ip: Faker::Internet.ip_v4_address
      }).resolve(
        name: 'Test User',
        phone_number: 667_089_810,
        auth_provider: {},
        gender: 0
      )
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'
require 'faker'

RSpec.describe Concepts::Users::Repository, type: :model do
  subject(:repository) do
    Concepts::Users::Repository.new
  end
  context 'create method' do
    it 'it success' do
      auth_provider = {
        credentials: {
          email: Faker::Internet.email,
          password: '12345678910'
        }
      }
      event_store = repository.create_user(auth_provider:, name: Faker::Name.name,
                                           phone_number: 667_089_810, gender: 0)
      expect(event_store).to have_published(an_event(UserWasCreated))
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'
require 'faker'

RSpec.describe Contexts::Helpers::Versioning, type: :model do
  subject(:repository) do
    Contexts::Helpers::Versioning
  end
  context 'create method' do
    let(:user) do
      User.create!(
        id: SecureRandom.uuid,
        name: Faker::Name.name,
        email: Faker::Internet.email,
        password_digest: '123456',
        phone_number: 667_089_810
      )
    end

    let(:post) do
      Post.create(
        id: SecureRandom.uuid,
        user_id: user.id,
        likes: []
      )
    end

    let(:extra_post) do
      Post.create(
        id: SecureRandom.uuid,
        user_id: user.id,
        likes: []
      )
    end

    it 'it success' do
      post.update(text: 'Text')
      post.reload
      expect(Contexts::Helpers::Versioning.versions(post.log_data).size).to eq(1)

      post.update(question: 'What is my purpose?')
      post.reload
      expect(Contexts::Helpers::Versioning.versions(post.log_data).size).to eq(2)
    end

    it 'it fails' do
      expect do
        Contexts::Helpers::Versioning.versions(extra_post.log_data)
      end.to raise_error(Contexts::Helpers::Errors::VersionsNotFoundError)
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'
require 'faker'

RSpec.describe Services::Versions, type: :model do
  subject(:repository) do
    Services::Versions
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

    it 'expects to return versioning of the record' do
      post.update(text: 'Text')
      post.reload
      expect(Services::Versions.versions(post.log_data).size).to eq(1)

      post.update(question: 'What is my purpose?')
      post.reload
      expect(Services::Versions.versions(post.log_data).size).to eq(2)
    end

    it 'it fails' do
      expect do
        Services::Versions.versions(extra_post.log_data)
      end.to raise_error(Services::Errors::VersionsNotFoundError)
    end
  end
end

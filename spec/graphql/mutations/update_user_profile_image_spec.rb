# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::UpdateUserProfileImageMutation, type: :request do
  let(:image) do
    fixture_file_upload(Rails.root.join('spec', 'fixtures', 'images', 'image.jpg'), 'image/jpg')
  end
  let(:txt) do
    fixture_file_upload(Rails.root.join('spec', 'fixtures', 'file.txt'), 'txt')
  end
  let(:user) do
    User.create(email: Faker::Internet.email, password_digest: 'test', phone_number: 667_089_810, name: 'test')
  end

  describe '.mutation passes' do
    it 'uploads new avatar' do
      expect do
        Mutations::UpdateUserProfileImageMutation.new(object: nil, field: nil, context: { current_user: user }).resolve(
          id: user.id,
          file: image
        )
      end.to_not raise_error
      user.reload
      expect(user.avatar_id).to_not be(nil)
      expect { Rails.configuration.s3.get_object(bucket: 'files', key: user.avatar_id) }.to_not raise_error
    end

    it 'cannot upload new avatar' do
      expect do
        Mutations::UpdateUserProfileImageMutation.new(object: nil, field: nil, context: { current_user: user }).resolve(
          id: user.id,
          file: txt
        )
      end.to raise_error(Services::Errors::FileInvalidTypeError)
    end
  end
end

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
    create(:user)
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
      mutation = Mutations::UpdateUserProfileImageMutation.new(object: nil, field: nil, context: { current_user: user }).resolve(
        id: user.id,
        file: txt
      )
      expect(mutation[:error][:message]).to be(Services::Errors::FileInvalidTypeError)
      expect(mutation[:status]).to eq(404)
    end
  end
end

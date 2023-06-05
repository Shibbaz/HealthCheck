# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::UpdatePostFileMutation, type: :request do
  let(:image) do
    fixture_file_upload(Rails.root.join('spec', 'fixtures', 'images', 'image.jpg'), 'image/jpg')
  end
  let(:txt) do
    fixture_file_upload(Rails.root.join('spec', 'fixtures', 'file.txt'), 'txt')
  end
  let(:user) do
    create(:user)
  end
  let(:post) do
    create(:post, user_id: user.id)
  end

  describe '.mutation passes' do
    it 'uploads new post file' do
      expect do
        Mutations::UpdatePostFileMutation.new(object: nil, field: nil, context: { current_user: user }).resolve(
          id: post.id,
          file: image
        )
      end.to_not raise_error
      post.reload
      expect(post.file_id).to_not be(nil)
      expect { Rails.configuration.s3.get_object(bucket: 'files', key: post.file_id) }.to_not raise_error
    end

    it 'cannot upload new post file' do
      expect do
        Mutations::UpdatePostFileMutation.new(object: nil, field: nil, context: { current_user: user }).resolve(
          id: post.id,
          file: txt
        )
      end.to raise_error(Services::Errors::FileInvalidTypeError)
    end
  end
end
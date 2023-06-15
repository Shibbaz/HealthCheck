# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Posts::UpdateFileMutation, type: :request do
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

  describe 'Mutation Success' do
    it 'expect to upload file successfully' do
      expect do
        Mutations::Posts::UpdateFileMutation.new(object: nil, field: nil, context: { current_user: user }).resolve(
          id: post.id,
          file: image
        )
      end.to_not raise_error
      post.reload
      expect(post.file_id).to_not be(nil)
      expect { Rails.configuration.s3.get_object(bucket: 'files', key: post.file_id) }.to_not raise_error
    end
  end
  
  describe 'Mutation Failure' do
    it 'expects to not upload txt file' do
      mutation = Mutations::Posts::UpdateFileMutation.new(object: nil, field: nil, context: { 
        ip: Faker::Internet.ip_v4_address,
        current_user: user 
      }).resolve(
        id: post.id,
        file: txt
      )      
      expect(mutation[:error][:message]).to eq(Services::Errors::FileInvalidTypeError)
      expect(mutation[:status]).to be(404)
    end
  end
end

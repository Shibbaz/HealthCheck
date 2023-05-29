# frozen_string_literal: true

require 'rails_helper'
require 'faker'

RSpec.describe Contexts::Helpers::Storage, type: :model do
  subject(:context) do
    Contexts::Helpers::Storage
  end
  context 'upload method' do
    let(:fake_s3) { {} }

    let(:client) do
      client = Aws::S3::Client.new(stub_responses: true)
      client.stub_responses(
        :create_bucket, lambda { |context|
          name = context.params[:bucket]
          if fake_s3[name]
            'BucketAlreadyExists' # standalone strings are treated as exceptions
          else
            fake_s3[name] = {}
            {}
          end
        }
      )
      client
    end

    it 'it success' do
      bucket_key = 'foo'
      client.create_bucket(bucket: bucket_key)
      file_key = 'obj'
      file = fixture_file_upload(Rails.root.join('spec', 'fixtures', 'images', 'image.jpg'), 'image/jpg')
      expect do
        Contexts::Helpers::Storage.upload(
          storage: client,
          bucket: bucket_key,
          key: file_key,
          file:
        )
      end.to_not raise_error
    end

    it 'it fails' do
      bucket_key = 'foo'
      client.create_bucket(bucket: bucket_key)
      file_key = 'obj'
      file = fixture_file_upload(Rails.root.join('spec', 'fixtures', 'file.txt'), 'txt')
      expect do
        Contexts::Helpers::Storage.upload(
          storage: client,
          bucket: bucket_key,
          key: file_key,
          file:
        )
      end.to raise_error(
        Contexts::Helpers::Errors::FileInvalidTypeError
      )
    end
  end
end

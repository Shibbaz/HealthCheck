# frozen_string_literal: true

require 'rspec'

describe 'Enhanced Stubbing Example Tests' do
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
    client.stub_responses(
      :get_object, lambda { |context|
        bucket = context.params[:bucket]
        key = context.params[:key]
        b_contents = fake_s3[bucket]
        if b_contents
          obj = b_contents[key]
          if obj
            { body: obj }
          else
            'NoSuchKey'
          end
        else
          'NoSuchBucket'
        end
      }
    )
    client.stub_responses(
      :put_object, lambda { |context|
        bucket = context.params[:bucket]
        key = context.params[:key]
        body = context.params[:body]
        b_contents = fake_s3[bucket]
        if b_contents
          b_contents[key] = body
          {}
        else
          'NoSuchBucket'
        end
      }
    )
    client
  end

  it 'raises an exception when a bucket is created twice' do
    client.create_bucket(bucket: 'foo')
    client.create_bucket(bucket: 'bar')
    expect do
      client.create_bucket(bucket: 'foo')
    end.to raise_error(Aws::S3::Errors::BucketAlreadyExists)
    expect(client.api_requests.size).to eq(3)
  end

  context 'bucket operations' do
    before do
      client.create_bucket(bucket: 'test')
    end

    it 'can write and retrieve an object' do
      client.put_object(bucket: 'test', key: 'obj', body: 'Hello!')
      obj = client.get_object(bucket: 'test', key: 'obj')
      expect(obj.body.read).to eq('Hello!')
      expect(client.api_requests.size).to eq(3)
      expect(client.api_requests.last[:params]).to eq(
        bucket: 'test',
        key: 'obj'
      )
    end

    it "raises the appropriate exception when a bucket doesn't exist" do
      expect do
        client.put_object(
          bucket: 'sirnotappearinginthistest',
          key: 'knight_sayings',
          body: 'Ni!'
        )
      end.to raise_error(Aws::S3::Errors::NoSuchBucket)
      expect(client.api_requests.size).to eq(2)
    end

    it "raises the appropriate exception when an object doesn't exist" do
      expect do
        client.get_object(bucket: 'test', key: '404NoSuchKey')
      end.to raise_error(Aws::S3::Errors::NoSuchKey)
      expect(client.api_requests.size).to eq(2)
    end
  end
end

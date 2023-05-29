# frozen_string_literal: true

require 'aws-sdk'

Aws.config.update(
  endpoint: ENV['S3_Endpoint'],
  access_key_id: ENV['S3_User_Name'],
  secret_access_key: ENV['S3_SECRET_KEY'],
  force_path_style: true,
  region: 'us-east-1'
)

Rails.configuration.s3 = if ['test'].include? ENV['RAILS_ENV']
        Aws::S3::Client.new(stub_responses: true)
      else
        Aws::S3::Client.new
      end

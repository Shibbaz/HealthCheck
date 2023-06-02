# frozen_string_literal: true
Services::Storage::Build.call(
    endpoint: ENV['S3_Endpoint'],
    access_key_id: ENV['S3_User_Name'],
    secret_access_key: ENV['S3_SECRET_KEY']
)

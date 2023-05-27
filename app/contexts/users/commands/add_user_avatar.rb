module Contexts
  module Users
    module Commands
      class AddUserAvatar
        def call(file:)
          file_key = SecureRandom.uuid
          Contexts::Helpers::Storage.upload(storage: $s3, bucket: ENV["S3_BUCKET"], key: file_key, file: file)
          file_key
        end
      end
    end
  end
end
module Contexts
  module Users
    module Commands
      class AddUserAvatar
        def call(event)
          user = User.find event.data[:id]
          file_key = SecureRandom.uuid
          data = event.data
          Contexts::Helpers::Storage.upload(
            storage: $s3, 
            bucket: ENV["S3_BUCKET"], 
            key: file_key, 
            file: data[:file]
          )
          event.data[:adapter].update(avatar_id: file_key)
        end
      end
    end
  end
end
# Adding file to post by current user by post id

module Concepts
  module Posts
    module Commands
      class AddPostFile
        def call(event)
          file_key = SecureRandom.uuid
          data = event.data
          Services::Storage::Upload.call(
            storage: Rails.configuration.s3,
            bucket: ENV['S3_BUCKET'],
            key: file_key,
            file: data[:file]
          )
          event.data[:adapter].update(file_id: file_key)
        end
      end
    end
  end
end

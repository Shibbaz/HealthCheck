# frozen_string_literal: true

module Concepts
  module Users
    module Commands
      class AddUserAvatar
        def call(event)
          file_key = SecureRandom.uuid
          data = event.data
          Services::Storage.upload(
            storage: Rails.configuration.s3,
            bucket: ENV['S3_BUCKET'],
            key: file_key,
            file: data[:file]
          )
          event.data[:adapter].update(avatar_id: file_key)
        end
      end
    end
  end
end

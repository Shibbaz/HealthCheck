# frozen_string_literal: true

module Services
  class Storage
    def self.upload(storage:, bucket:, key:, file:)
      raise Services::Errors::FileInvalidTypeError if File.extname(file.path) != '.jpg'

      config = {
        key:,
        bucket:
      }
      storage.put_object(
        key: config[:key],
        body: file.read,
        bucket: config[:bucket]
      )
    end
  end
end

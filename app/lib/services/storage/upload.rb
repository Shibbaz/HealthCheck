require 'aws-sdk'

module Services
  module Storage
    class Upload
      def self.call(bucket:, key:, file:, storage: Rails.configuration.s3)
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
end

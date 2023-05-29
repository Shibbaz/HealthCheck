module Contexts
  module Helpers
    class Storage
      def self.upload(storage:, bucket:, key:, file:)
        raise Contexts::Helpers::Errors::FileInvalidTypeError.new if File.extname(file.path) != ".jpg"

        config = {
          key: key,
          bucket: bucket
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

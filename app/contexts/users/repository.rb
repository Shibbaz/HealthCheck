module Contexts
  module Users
    class Repository
      attr_reader :adapter

      def initialize(adapter: User)
        @adapter = adapter
      end

      def create_user(auth_provider:, name:, phone_number:, gender:)
        event = UserWasCreated.new(data: {
          name: name,
          email: auth_provider&.[](:credentials)&.[](:email),
          password: auth_provider&.[](:credentials)&.[](:password),
          phone_number: phone_number,
          gender: gender,
          adapter: @adapter
        })
        $event_store.publish(event, stream_name: SecureRandom.uuid)
      end

      def upload(id:, file:)
        event = UserAvatarWasUploaded.new(data: {
          id: id,
          file: file,
          adapter: @adapter
        })
        $event_store.publish(event, stream_name: SecureRandom.uuid)
      end
    end
  end
end

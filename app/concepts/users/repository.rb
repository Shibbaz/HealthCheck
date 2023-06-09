module Concepts
  module Users
    class Repository
      attr_reader :adapter

      def initialize(adapter: User)
        @adapter = adapter
      end

      def create_user(auth_provider:, name:, phone_number:, gender:)
        event_type = Services::Records.build_event(adapter:, event_type: 'Created')
        data = {
          name: name, 
          email: auth_provider&.[](:credentials)&.[](:email),
          password: auth_provider&.[](:credentials)&.[](:password),
          phone_number: phone_number,
          gender: gender,
          adapter: @adapter
        }
        Services::Events::Publish.call(data:, event_type:)
      end

      def upload(id:, file:)
        event_type = UserAvatarWasUploaded
        data = OpenStruct.new(id: id, file: file, adapter: @adapter)
        Services::Events::Publish.call(data:, event_type:)
      end

      def update(args:, current_user:)
        event_type = Services::Records.build_event(adapter:, event_type: 'Updated')
        data = OpenStruct.new(adapter: @adapter, args: args, current_user: current_user)
        Services::Events::Publish.call(data:, event_type:)
      end

      def add_follow(args:, current_user_id:)
        event_type = Services::Records.build_event(adapter:, event_type: 'Followed')
        data = OpenStruct.new(adapter: @adapter, args: args, current_user_id: current_user_id)
        Services::Events::Publish.call(data:, event_type:)
      end
    end
  end
end

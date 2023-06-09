# frozen_string_literal: true

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
          name:,
          email: auth_provider&.[](:credentials)&.[](:email),
          password: auth_provider&.[](:credentials)&.[](:password),
          phone_number:,
          gender:,
          adapter: @adapter
        }
        Services::Events::Publish.call(data:, event_type:)
      end

      def upload(id:, file:)
        event_type = UserAvatarWasUploaded
        data = {
          id:,
          file:,
          adapter: @adapter
        }
        Services::Events::Publish.call(data:, event_type:)
      end

      def update(args:, current_user:)
        event_type = Services::Records.build_event(adapter:, event_type: 'Updated')
        data = {
          adapter: @adapter,
          args: args,
          current_user: current_user
        }
        Services::Events::Publish.call(data:, event_type:)
      end

      def add_follow(args:, current_user_id:)
        event_type = Services::Records.build_event(adapter:, event_type: 'Followed')
        data = {
          id: args[:id],
          current_user_id:,
          adapter: @adapter
        }
        Services::Events::Publish.call(data:, event_type:)
      end

      def add_transfer_platform(args:, current_user:)
        event_type = StripeKeyWasAdded
        data = {
          adapter: @adapter,
          args: args,
          current_user: current_user
        }
        Services::Events::Publish.call(data:, event_type:)
      end

      def make_transfer(args:, current_user:)
        event_type = UserWasDonated
        data = {
          adapter: @adapter,
          args: args,
          current_user: current_user
        }
        Services::Events::Publish.call(data:, event_type:)
      end
    end
  end
end

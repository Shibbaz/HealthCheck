# frozen_string_literal: true

module Contexts
  module Users
    class Repository
      attr_reader :adapter

      def initialize(adapter: User)
        @adapter = adapter
      end

      def create_user(auth_provider:, name:, phone_number:, gender:)
        event_type = Contexts::Helpers::Records.build_event(adapter:, event_type: 'Created')
        data = {
          name:,
          email: auth_provider&.[](:credentials)&.[](:email),
          password: auth_provider&.[](:credentials)&.[](:password),
          phone_number:,
          gender:,
          adapter: @adapter
        }
        Contexts::Events::Publish.call(data: data, event_type: event_type)
      end

      def upload(id:, file:)
        event_type = UserAvatarWasUploaded
        data = {
          id:,
          file:,
          adapter: @adapter
        }
        Contexts::Events::Publish.call(data: data, event_type: event_type)
      end
    end
  end
end

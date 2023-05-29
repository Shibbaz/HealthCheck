# frozen_string_literal: true

module Contexts
  module Users
    class Repository
      attr_reader :adapter

      def initialize(adapter: User)
        @adapter = adapter
      end

      def create_user(auth_provider:, name:, phone_number:, gender:)
        event = UserWasCreated.new(data: {
                                     name:,
                                     email: auth_provider&.[](:credentials)&.[](:email),
                                     password: auth_provider&.[](:credentials)&.[](:password),
                                     phone_number:,
                                     gender:,
                                     adapter: @adapter
                                   })
        Rails.configuration.event_store.publish(event, stream_name: SecureRandom.uuid)
      end

      def upload(id:, file:)
        event = UserAvatarWasUploaded.new(data: {
                                            id:,
                                            file:,
                                            adapter: @adapter
                                          })
        Rails.configuration.event_store.publish(event, stream_name: SecureRandom.uuid)
      end
    end
  end
end

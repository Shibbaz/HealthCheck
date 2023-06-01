# frozen_string_literal: true

module Contexts
  module Notifications
    class Repository
      attr_reader :adapter

      def initialize(adapter: Notification)
        @adapter = adapter
      end

      def notificationOnComment(type:, record:, current_user_id:)
        event_type = UserWasNotifiedOnComment
        event = event_type.new(data: {
                                type: type,
                                 record: record,
                                 current_user_id: current_user_id,
                                 adapter: @adapter
                               })
        Rails.configuration.event_store.publish(event, stream_name: SecureRandom.uuid)
      end

      def notificationOnLike(record:, current_user_id:)
        event_type = UserWasNotifiedOnLike
        event = event_type.new(data: {
                                 record: record,
                                 current_user_id: current_user_id,
                                 adapter: @adapter
                               })
        Rails.configuration.event_store.publish(event, stream_name: SecureRandom.uuid)
      end
    end
  end
end

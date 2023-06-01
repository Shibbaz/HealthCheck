# frozen_string_literal: true

module Concepts
  module Notifications
    class Repository
      attr_reader :adapter

      def initialize(adapter: Notification)
        @adapter = adapter
      end

      def notificationOnComment(type:, record:, current_user_id:)
        event_type = UserWasNotifiedOnComment
        data = {
          type: type,
          record: record,
          current_user_id: current_user_id,
          adapter: @adapter
        }
        Services::Events::Publish.call(data: data, event_type: event_type)
      end

      def notificationOnLike(record:, current_user_id:)
        event_type = UserWasNotifiedOnLike
        data = {
          record: record,
          current_user_id: current_user_id,
          adapter: @adapter
        }
        Services::Events::Publish.call(data: data, event_type: event_type)
      end
    end
  end
end

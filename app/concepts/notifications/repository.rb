module Concepts
  module Notifications
    class Repository
      attr_reader :adapter

      def initialize(adapter: Notification)
        @adapter = adapter
      end

      def notificationOnComment(type:, record:, current_user_id:)
        event_type = UserWasNotifiedOnComment
        data = OpenStruct.new(type: type, record: record, current_user_id: current_user_id, adapter: @adapter)
        Services::Events::Publish.call(data:, event_type:)
      end

      def notificationOnLike(record:, current_user_id:)
        event_type = UserWasNotifiedOnLike
        data = OpenStruct.new(record: record, current_user_id: current_user_id, adapter: @adapter)
        Services::Events::Publish.call(data:, event_type:)
      end
    end
  end
end

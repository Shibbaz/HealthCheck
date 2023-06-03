# frozen_string_literal: true

module Concepts
  module Notifications
    module Commands
      class NotificationOnComment
        def call(event)
          data = event.data

          adapter = data[:adapter]
          record = data[:record]
          current_user_id = data[:current_user_id]

          notification_adapter = record.class
          return unless !record.nil? && notification_adapter.eql?(Comment)

          adapter.create(
            activity: 'Comment',
            destination_id: record.id,
            adapter: notification_adapter.to_s,
            author_id: current_user_id,
            receiver_id: record.user_id
          )
        end
      end
    end
  end
end

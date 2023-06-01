# frozen_string_literal: true

module Contexts
  module Notifications
    module Commands
      class NotificationOnLike
        def call(event)
          data = event.data
          record = data[:record]
          current_user_id = data[:current_user_id]
          notification_type = record.class
          if !current_user_id.eql?(record.user_id)
            adapter = data[:adapter]
            adapter.create(
              activity: "Like",
              destination_id: record.id,
              adapter: notification_type.to_s,
              author_id: current_user_id,
              receiver_id: record.user_id
            )
          end
        end
      end
    end
  end
end

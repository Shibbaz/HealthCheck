module Subscriptions
  class NotificationWasSent < Subscriptions::BaseSubscription
    field :notification, Types::Concepts::NotificationType, null: false
    argument :user_id, ID

    def subscribe(user_id)
      notification = Notification.where(receiver_id: user_id.values.first).load_async.order(:updated_at).last
      exit if notification.eql? nil
      {
        notification:
      }
    end
  end
end

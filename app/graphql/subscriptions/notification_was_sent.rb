module Subscriptions
  class NotificationWasSent < Subscriptions::BaseSubscription
    field :notification, Types::NotificationType, null: false
    argument :user_id, ID
    
    def subscribe(user_id)
      notification = Notification.where(receiver_id: user_id.values.first).order(:updated_at).last
      if notification.eql? nil
        exit
      end
      {
        notification: notification
      }
    end
  end
end

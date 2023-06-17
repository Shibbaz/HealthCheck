# Notifications subscription

module Subscriptions
  class NotificationWasSent < Subscriptions::BaseSubscription
    field :notification, Types::Concepts::NotificationType, null: false
    argument :user_id, ID

    def subscribe(user_id)
      byebug

      render json => Notification.where(receiver_id: user_id.values.first).load_async.order(:updated_at).last
    end
  end
end

module Types
  class SubscriptionType < Types::BaseObject
    field :notification_was_sent, subscription: Subscriptions::NotificationWasSent
  end
end

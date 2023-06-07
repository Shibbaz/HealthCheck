module Types
  class SubscriptionType < Types::BaseObject
    field :notification_was_sent, subscription: Subscriptions::NotificationWasSent
    field :suggestion_was_sent, subscription: Subscriptions::SuggestionWasSent
  end
end

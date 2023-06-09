module Types
  module Registry
    class SubscriptionType < Types::Base::Object
      field :notification_was_sent, subscription: Subscriptions::NotificationWasSent
      field :suggestion_was_sent, subscription: Subscriptions::SuggestionWasSent
    end
  end
end
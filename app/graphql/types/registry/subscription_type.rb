module Types
  module Registry
    class SubscriptionType < Types::Base::Object
      field :notification_was_sent, subscription: Subscriptions::NotificationWasSent, null: false do
        extension GraphAttack::RateLimit, threshold: 15, interval: 60
      end
      field :suggestion_was_sent, subscription: Subscriptions::SuggestionWasSent, null: false do
        extension GraphAttack::RateLimit, threshold: 15, interval: 60
      end
    end
  end
end
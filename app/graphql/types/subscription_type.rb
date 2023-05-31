module Types
  class SubscriptionType < Types::BaseObject
    field :notification_comment_was_sent, subscription: Subscriptions::NotificationCommentWasSent
    field :notification_post_was_sent, subscription: Subscriptions::NotificationPostWasSent
  end
end

module Types
  class SubscriptionType < Types::BaseObject
    field :notification_on_posts, subscription: Subscriptions::NotificationOnPosts
    field :notification_on_comments, subscription: Subscriptions::NotificationOnComments

  end
end

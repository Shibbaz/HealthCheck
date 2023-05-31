module Subscriptions
  class NotificationCommentWasSent < Subscriptions::BaseSubscription
    field :post, Types::PostType, null: false

    argument :user_id, ID

    def notification(user_id)
      post = Comment.where(user_id).order(:updated_at).last
      {
        post: post
      }
    end

    def subscribe(user_id)
      notification(user_id)
    end

    def update(user_id)
      notification(user_id)
    end
  end
end

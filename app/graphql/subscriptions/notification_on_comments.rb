module Subscriptions
  class NotificationOnComments < Subscriptions::BaseSubscription
    field :comment, Types::PostType, null: false

    argument :user_id, ID

    def notification(user_id)
      comment = Comment.where(user_id).order(:updated_at).last
      {
        comment: comment
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

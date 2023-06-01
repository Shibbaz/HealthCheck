class Notification < ApplicationRecord
    after_save :graphql_notification_on_posts

    def graphql_notification_on_posts
        HealthSchema.subscriptions.trigger(:notification_was_sent, {}, self.to_json, scope: self.receiver_id)
    end
end

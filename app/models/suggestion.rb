class Suggestion < ApplicationRecord
    self.cache_versioning = true
    after_save :graphql_suggestion_on_users

    def graphql_suggestion_on_users
      HealthSchema.subscriptions.trigger(:suggestion_was_sent, {}, to_json, scope: receiver_id)
    end
end

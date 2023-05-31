# frozen_string_literal: true

class Comment < ApplicationRecord
  after_save :graphql_notification_on_comments
  after_update :graphql_notification_on_comments

  has_logidze
  belongs_to :user
  belongs_to :post

  def graphql_notification_on_comments
    HealthSchema.subscriptions.trigger(:notification_comment_was_sent, {}, {comment: self.as_json}, scope: self.user_id)
  end
end

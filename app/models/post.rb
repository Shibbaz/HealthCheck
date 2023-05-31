# frozen_string_literal: true

require 'obscenity/active_model'

class Post < ApplicationRecord
  after_save :graphql_notification_on_posts
  after_update :graphql_notification_on_posts

  has_logidze
  belongs_to :user
  has_many :comments
  validates :user_id, format: { with: /[a-f0-9]{8}-[a-f0-9]{4}-4[a-f0-9]{3}-[89aAbB][a-f0-9]{3}-[a-f0-9]{12}/ }
  validates :text, obscenity: {
                     sanitize: true,
                     replacement: '[censored]'
                   },
                   length: {
                     maximum: 1000,
                     message: 'The review must not exceed 1000 characters'
                   }

  scope :filter_by_feeling, lambda { |value|
    where(feeling: value).order(arel_table['feeling'].asc)
  }

  scope :filter_by_likes, lambda {
    sort { |x, y| x.likes.length <=> y.likes.length }
  }

  scope :filter_by_created_at, lambda {
    order(arel_table['created_at'].asc)
  }

  scope :show_users_content, lambda { |ids|
    where(user_id: ids).order(arel_table['created_at'].desc)
  }
  def graphql_notification_on_posts
    HealthSchema.subscriptions.trigger(:notification_on_posts, {}, {post: self.as_json}, scope: self.user_id)
  end
end

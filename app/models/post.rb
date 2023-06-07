# frozen_string_literal: true

require 'obscenity/active_model'

class Post < ApplicationRecord
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

  scope :visible_content, lambda { |visibility, id|
    if visibility.eql? true
      where(user_id: id, visibility: visibility).order(arel_table['created_at'].desc)
    else
      show_users_content(id).order(arel_table['created_at'].desc)
    end
  }
end

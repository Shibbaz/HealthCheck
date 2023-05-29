# frozen_string_literal: true

class Comment < ApplicationRecord
  has_logidze
  belongs_to :user
  belongs_to :post
end

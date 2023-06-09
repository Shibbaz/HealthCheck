class Comment < ApplicationRecord
  has_logidze
  belongs_to :user
  belongs_to :post
end

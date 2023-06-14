class Comment < ApplicationRecord
  self.cache_versioning = true
  has_logidze
  belongs_to :user
  belongs_to :post
end

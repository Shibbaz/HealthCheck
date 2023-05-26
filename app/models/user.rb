class User < ApplicationRecord
  has_secure_password
  after_create :set_followers_attribute
  has_many :posts
  has_many :comments

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  include PgSearch::Model
  pg_search_scope :search, against: [:email, :name]
  VALID_PHONE_NUMBER_REGEX = /\d{9}/
  validates :phone_number, presence: true, length: {maximum: 15},
    format: {with: VALID_PHONE_NUMBER_REGEX}

  def set_followers_attribute
    update(followers: [id])
  end
end

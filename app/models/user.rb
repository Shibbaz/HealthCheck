# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  after_create :set_followers_attribute
  has_many :posts
  has_many :comments

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  include PgSearch::Model
  pg_search_scope :search, against: %i[email name]
  VALID_PHONE_NUMBER_REGEX = /\d{9}/
  validates :phone_number, presence: true, length: { maximum: 15 },
                           format: { with: VALID_PHONE_NUMBER_REGEX }

  def stripe_transaction(destination:, amount:, currency:)
    source = Services::Payments::Transfer.account(self.stripe_key)
    destination = Services::Payments::Transfer.account(destination.stripe_key)
    Services::Payments::Transfer.transfer(source: source, destination: destination, amount: amount, currency: currency)
  end

  def set_followers_attribute
    update(followers: [id])
  end
end

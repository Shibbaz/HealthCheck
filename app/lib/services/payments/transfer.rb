require 'stripe'
module Services
  module Payments
    class Transfer
      def self.account(api_key)
          Stripe::Account.retrieve(api_key)
        rescue Stripe::PermissionError => e
          {
            error: e.message
          }
      end

      def self.transfer(account:, ammount:, currency:)
          Stripe::Transfer.create({
            amount: ammount,
            currency: currency,
            destination: account.id,
          })
        rescue Stripe::InvalidRequestError => e
          {
            error: e.message
          }
      end
    end
  end
end
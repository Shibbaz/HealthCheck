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

      #The provided key 'sk_test_****************Vs7p' does not have access to account - bug '

      def self.transfer(source:, destination:, amount:, currency:)
          Stripe::Transfer.create({
            amount: amount,
            currency: currency,
            destination: destination.id,
          },
            {
              stripe_account: '{{source.id}}'
            }
          )
        rescue Stripe::InvalidRequestError => e
          {
            error: e.message
          }
      end
    end
  end
end
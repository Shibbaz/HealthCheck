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
      def connect
        response = HTTParty.post("https://connect.stripe.com/oauth/token",
        query: {
          client_secret: ENV["STRIPE_SECRET_KEY"],
          code: params[:code],
          grant_type: "authorization_code"
        }
      )
      end

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
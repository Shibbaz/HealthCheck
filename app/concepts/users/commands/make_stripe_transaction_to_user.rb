# frozen_string_literal: true

module Concepts
    module Users
        module Commands
            class MakeStripeTransactionToUser
                def call(event)
                    data = event.data
                    error_type = Services::Records.build_error(adapter: data[:adapter])
                    source ||= data[:current_user]
                    destination ||= data[:adapter].find(data[:args][:id]).stripe_key
                    amount = data[:args][:amount]
                    currency = data[:args][:currency]
                    (source.nil? || destination.nil?)  ? (raise error_type) : nil
                    source.transfer(destination: destination, amount: amount, currency: currency)
                rescue => e
                    {
                      error: e.message,
                      status: 404
                    }
                end
            end
        end
    end
end
  
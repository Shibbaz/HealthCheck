# frozen_string_literal: true

module Concepts
    module Users
        module Commands
            class MakeStripeTransactionToUser
                def call(event)
                    data = event.data
                    error_type = Services::Records.build_error(adapter: data[:adapter])
                    transfer_source ||= data[:current_user]
                    destination ||= data[:adapter].find(data[:args][:id])
                    amount = data[:args][:amount]
                    currency = data[:args][:currency]
                    (transfer_source.nil? || destination.nil?)  ? (raise error_type) : nil
                    transfer_source.stripe_transaction(destination: destination, amount: amount, currency: currency)
                end
            end
        end
    end
end
  
# frozen_string_literal: true

module Concepts
    module Users
        module Commands
            class AddStripeKeyToUser
                def call(event)
                    data = event.data
                    Services::Payments::Transfer.account(data[:args][:stripe_key])
                    error_type = Services::Records.build_error(adapter: data[:adapter])
                    record = data[:current_user]
                    record.with_lock do
                        record.update(stripe_key: data[:args][:stripe_key])
                    end
                end
            end
        end
    end
end
  
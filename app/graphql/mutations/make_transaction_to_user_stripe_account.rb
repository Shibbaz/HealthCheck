# frozen_string_literal: true

module Mutations
    class MakeTransactionToUserStripeAccount < BaseMutation
      argument :id, ID, required: true
      field :status, Int, null: false
  
      def resolve(**args)
        Services::Validations::Authenticate.call(context:)
        Concepts::Users::Repository.new.make_transfer(args:, current_user: context[:current_user])
        { status: 200}
      rescue  => e
        raise GraphQL::ExecutionError, e.message
      end
    end
  end
  
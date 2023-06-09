# frozen_string_literal: true

module Resolvers
  class RetrieveDetailsOfUser < GraphQL::Schema::Resolver
    description 'details of user'

    type Types::UserType, null: false
    argument :user_id, ID, required: false

    def resolve(**args)
      Services::Validations::Authenticate.call(context:)
      Concepts::Users::Queries::Details.new.call(args:, context:)
    rescue ActiveRecord::RecordNotFound => e
      raise GraphQL::ExecutionError, e.message
    end
  end
end

# Listing details of User, Query can be found in doc/graphql/resolvers

module Resolvers
  class RetrieveDetailsOfUser < Resolvers::BaseResolver
    description 'details of user'

    type Types::Concepts::UserType, null: false
    argument :user_id, ID, required: false

    def resolve(**args)
      Services::Validations::Authenticate.call(context:)
      Concepts::Users::Queries::Details.new.call(args:, context:)
    rescue ActiveRecord::RecordNotFound => e
      raise GraphQL::ExecutionError, e.message
    end
  end
end

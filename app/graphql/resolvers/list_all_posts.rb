# frozen_string_literal: true

module Resolvers
  class ListAllPosts < GraphQL::Schema::Resolver
    description 'list all posts and filter it if'

    type [Types::PostType], null: false
    argument :filters, Types::PostFilter, required: false

    def resolve(**args)
      Services::Validations::Authenticate.call(context:)
      args = args.merge({
                          user_id: context[:current_user].id
                        })
      Concepts::Posts::Queries::AllRecords.new.call(args:)
    rescue ActiveRecord::RecordNotFound => e
      raise GraphQL::ExecutionError, e.message
    end
  end
end

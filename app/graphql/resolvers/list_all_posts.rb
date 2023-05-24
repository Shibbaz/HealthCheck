module Resolvers
  class ListAllPosts < GraphQL::Schema::Resolver
    description "list all posts and filter it if"

    type [Types::PostType], null: false
    argument :filters, Types::PostFilter, required: true

    def resolve(**args)
      # Helpers::Authenticate.new.call(context: context)
      Contexts::Posts::Queries::AllRecords.new.call(args: args)
    rescue ActiveRecord::RecordNotFound => error
      raise GraphQL::ExecutionError, error.message
    end
  end
end

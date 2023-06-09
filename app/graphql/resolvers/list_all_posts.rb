# Listing all Posts, Query can be found in doc/graphql/resolvers

module Resolvers
  class ListAllPosts < GraphQL::Schema::Resolver
    description 'list all posts and filter it if'

    type [Types::Concepts::PostType], null: false
    
    argument :page, Integer, required: false
    argument :limit, Integer, required: false
    argument :filters, Types::Filters::PostFilter, required: false
    argument :usr, ID, required: false, default_value: nil


    def resolve(**args)
      Services::Validations::Authenticate.call(context:)
      
      if args[:usr].present?
        user ||= User.find(args[:usr])
        raise Concepts::Users::Errors::UserNotFoundError if user == nil
        visibility = user.followers.include?(context[:current_user].id)
        args = args.merge(
          {
            visibility: visibility,
          }
        )
        return Concepts::Posts::Queries::AllRecords.new.call(args:).page(args[:page]).per(args[:limit])
        raise GraphQL::ExecutionError, e.message
      end

      if args[:usr].nil?
        args = args.merge({
          user_id: context[:current_user].id,
          visibility: false
        })
      end
      Concepts::Posts::Queries::AllRecords.new.call(args:).page(args[:page]).per(args[:limit])
    rescue ActiveRecord::RecordNotFound => e
      raise GraphQL::ExecutionError, e.message
    end
  end
end

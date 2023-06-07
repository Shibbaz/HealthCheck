# frozen_string_literal: true

module Resolvers
  class ListAllPosts < GraphQL::Schema::Resolver
    description 'list all posts and filter it if'

    type [Types::PostType], null: false
    
    argument :page, Integer, required: false
    argument :limit, Integer, required: false
    argument :filters, Types::PostFilter, required: false
    argument :user_id, ID, required: false


    def resolve(**args)
      Services::Validations::Authenticate.call(context:)
      
      if !args[:user_id].nil?
        user ||= User.find(args[:user_id])
        raise Concepts::Users::Errors::UserNotFoundError if user == nil
        visibility = user.followers.include?(context[:current_user])
        args = args.merge(
          {
            visibility: visibility,
          }
        )
      end

      if args[:user_id].nil?
        args = args.merge({
          user_id: context[:current_user].id,
          visibility: nil
        })
      end
      Concepts::Posts::Queries::AllRecords.new.call(args:).page(args[:page]).per(args[:limit])
    rescue ActiveRecord::RecordNotFound => e
      raise GraphQL::ExecutionError, e.message
    end
  end
end

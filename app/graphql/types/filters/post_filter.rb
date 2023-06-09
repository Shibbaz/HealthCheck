module Types
  module Filters
    class PostFilter < Types::Base::InputObject
      argument :feeling, Int, required: false
      argument :created_at, GraphQL::Types::Boolean, required: false
      argument :likes, GraphQL::Types::Boolean, required: false
      argument :followers, GraphQL::Types::Boolean, required: false
    end
  end
end

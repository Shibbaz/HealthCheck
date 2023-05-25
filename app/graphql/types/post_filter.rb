module Types
  class PostFilter < ::Types::BaseInputObject
    argument :feeling, Int, required: false
    argument :created_at, GraphQL::Types::Boolean, required: false
    argument :likes, GraphQL::Types::Boolean, required: false
  end
end

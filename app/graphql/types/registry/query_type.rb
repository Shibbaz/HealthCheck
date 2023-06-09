# frozen_string_literal: true

module Types
  module Registry
    class QueryType < Types::Base::Object
      # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
      include GraphQL::Types::Relay::HasNodeField
      include GraphQL::Types::Relay::HasNodesField
      # field :allposts, resolver: Resolvers::ListAllPosts
      field :allposts, resolver: Resolvers::ListAllPosts
      field :retrieveDetailsOfUser, resolver: Resolvers::RetrieveDetailsOfUser
    end
  end
end

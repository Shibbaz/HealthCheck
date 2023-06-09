# frozen_string_literal: true

module Types
  module Registry
    class QueryType < Types::Base::Object
      # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
      include GraphQL::Types::Relay::HasNodeField
      include GraphQL::Types::Relay::HasNodesField
      # field :allposts, resolver: Resolvers::ListAllPosts
      field :allposts, resolver: Resolvers::ListAllPosts, null: false do
        extension GraphAttack::RateLimit, threshold: 15, interval: 60
      end
      field :retrieveDetailsOfUser, resolver: Resolvers::RetrieveDetailsOfUser, null: false do
        extension GraphAttack::RateLimit, threshold: 15, interval: 60
      end
    end
  end
end

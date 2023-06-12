module Resolvers
    class BaseResolver < GraphQL::Schema::Resolver
        include GraphQL::FragmentCache::ObjectHelpers
    end
end
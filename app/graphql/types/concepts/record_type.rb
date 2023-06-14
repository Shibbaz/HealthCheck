module Types
  module Concepts
    class Concepts::RecordType < Types::Base::Object
      field :likes, [Types::Concepts::UserType], null: false
      field :likes_counter, Int, null: false
      field :versions, [GraphQL::Types::JSON], null: false
      field :created_at, GraphQL::Types::ISO8601DateTime, null: false
      field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

      def likes
        outer_path = context.namespace(:interpreter)[:current_path]
        Services::Records.for(User).load_many(object.likes) do |user|
          context.namespace(:interpreter)[:current_path] = outer_path
          cache_fragment(user, context: context)
        end
      end

      def likes_counter
        cache_fragment(object_cache_key: "record_likes_counter", expires_in: 1.hour) {
          object.likes.size
        }
      end

      def versions
        cache_fragment(object_cache_key: "record_versions", expires_in: 1.hour) {
          Services::Versions.versions(object.log_data)
      }
      rescue Concepts::Helpers::Errors::VersionsNotFoundError
        []
      end
    end
  end
end
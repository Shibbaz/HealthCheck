module Types
  module Concepts
    class Concepts::SuggestionType < Types::Base::Object
      field :authors, [Types::Concepts::UserType], null: false
      field :user, Types::Concepts::UserType, null: false

      def user
        cache_fragment(object_cache_key: "suggestion_user", expires_in: 5.minutes) {
          Services::Records.for(User).load(object.user)
        }
      end
    end
  end
end
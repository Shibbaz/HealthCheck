module Types
  module Concepts
    class Concepts::SuggestionType < Types::Base::Object
      field :authors, [Types::Concepts::UserType], null: false
      field :user, Types::Concepts::UserType, null: false
    end
  end
end
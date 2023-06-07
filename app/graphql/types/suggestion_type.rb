module Types
  class SuggestionType < Types::BaseObject
    field :authors, [Types::UserType], null: false
    field :user, Types::UserType, null: false
  end
end

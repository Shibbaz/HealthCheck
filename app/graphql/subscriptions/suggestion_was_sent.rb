module Subscriptions
  class SuggestionWasSent < Subscriptions::BaseSubscription
    field :suggestion, Types::SuggestionType, null: false
    argument :user_id, ID, required: true

    def subscribe(user_id:)
      user = User.find(user_id)
      suggestion = Services::Suggestions.suggest(user: user)
      exit if suggestion.eql? nil
      {
        suggestion:
      }
    end
  end
end

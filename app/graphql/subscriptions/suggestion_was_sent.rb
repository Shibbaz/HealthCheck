# Suggestion User to follow Subscription for Current User

module Subscriptions
  class SuggestionWasSent < Subscriptions::BaseSubscription
    field :suggestion, Types::Concepts::SuggestionType, null: false
    argument :user_id, ID, required: true

    def subscribe(user_id:)
      user = User.find(user_id)
      suggestion = Services::Suggestions.suggest(user: user)
      exit if suggestion.eql? nil
      OpenStruct.new(suggestion: suggestion)
    end
  end
end

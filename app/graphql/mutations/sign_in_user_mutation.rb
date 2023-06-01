# frozen_string_literal: true

module Mutations
  class SignInUserMutation < BaseMutation
    argument :credentials, Types::AuthProviderCredentialsInput, required: false

    field :user, Types::UserType, null: true
    field :token, String, null: true

    def resolve(credentials: nil)
      Concepts::Users::Queries::SignInUser.new.call(credentials:, context:)
    end
  end
end

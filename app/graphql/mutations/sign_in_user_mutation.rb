# frozen_string_literal: true

module Mutations
  class SignInUserMutation < BaseMutation
    argument :credentials, Types::AuthProviderCredentialsInput, required: false

    field :user, Types::UserType, null: true
    field :token, String, null: true
    field :error, Types::ErrorType, null: false

    def resolve(credentials: nil)
      Concepts::Users::Queries::SignInUser.new.call(credentials:, context:)
    rescue => e
      return {
        error: {
          message: e.class,
        },
        status: 404
      }
    end
  end
end

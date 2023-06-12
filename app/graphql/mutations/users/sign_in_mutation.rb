# Sign in User mutation, Graphql script can be found in doc/graphql/mutations

module Mutations
  module Users
    class SignInMutation < BaseMutation
      argument :credentials, Types::AuthProviderCredentialsInput, required: false

      field :user, Types::Concepts::UserType, null: true
      field :token, String, null: true
      field :error, Types::ErrorType, null: false

      def resolve(credentials: nil)
        Concepts::Users::Queries::SignInUser.new.call(credentials:, context:)
      rescue => e
        Error.json(e)
      end
    end
  end
end

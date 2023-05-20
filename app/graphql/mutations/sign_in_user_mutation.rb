module Mutations
  class SignInUserMutation < BaseMutation
    argument :credentials, Types::AuthProviderCredentialsInput, required: false

    field :user, Types::UserType, null: true
    field :token, String, null: true

    def resolve(credentials: nil)
      Contexts::Users::Queries::SignInUser.new.call(credentials: credentials, context: context)
    end
  end
end

# frozen_string_literal: true

module Mutations
  class CreateUserMutation < BaseMutation
    # often we will need input types for specific mutation
    # in those cases we can define those input types in the mutation class itself
    class AuthProviderSignupData < Types::BaseInputObject
      argument :credentials, Types::AuthProviderCredentialsInput, required: false
    end

    argument :name, String, required: true
    argument :auth_provider, AuthProviderSignupData, required: false
    argument :phone_number, Int, required: true
    argument :gender, Int, required: true

    type Types::UserType
    field :user, ::Types::UserType, null: false
    field :status, Int, null: false

    def resolve(name: nil, phone_number: nil, auth_provider: nil, gender: nil)
      user = Concepts::Users::Repository.new.create_user(auth_provider:, name:,
                                                         phone_number:, gender:)
      User.find_by(email: auth_provider[:credentials][:email])
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

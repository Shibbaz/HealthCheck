module Types
  class MutationType < Types::BaseObject
    field :create_user, mutation: Mutations::CreateUserMutation
    field :signin_user, mutation: Mutations::SignInUserMutation
  end
end

module Types
  class AuthProviderCredentialsInput < Base::InputObject
    # the name is usually inferred by class name but can be overwritten
    graphql_name 'AUTH_PROVIDER_CREDENTIALS'

    argument :email, String, required: true
    argument :password, String, required: true
  end
end

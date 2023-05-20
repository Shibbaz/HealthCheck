module Contexts
  module Users
    module Queries
      class SignInUser
        def call(credentials:, context:)
          # basic validation

          return unless credentials
          user = User.find_by email: credentials[:email]

          # ensures we have the correct user
          return unless user
          return unless user.authenticate(credentials[:password])

          # use Ruby on Rails - ActiveSupport::MessageEncryptor, to build a token
          crypt = ActiveSupport::MessageEncryptor.new(Rails.application.credentials.secret_key_base.byteslice(0..31))
          token = crypt.encrypt_and_sign("user-id:#{user.id}")
          context[:session][:token] = token
          {user: user, token: token}
        end
      end
    end
  end
end

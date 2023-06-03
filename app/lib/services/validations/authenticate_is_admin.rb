module Services
  module Validations
    class AuthenticateIsAdmin
      def self.call(user:)
        return unless user.is_admin == false

        (raise GraphQL::ExecutionError, "user #{user.name} does not have admin permissions")
      end
    end
  end
end

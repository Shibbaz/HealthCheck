module Helpers
    class AuthenticateIsAdmin
      def call(user:)
        user.is_admin == false ? (raise GraphQL::ExecutionError, "user #{user.name} does not have admin permissions") : nil
      end
    end
  end
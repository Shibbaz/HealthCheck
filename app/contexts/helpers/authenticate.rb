# frozen_string_literal: true

module Contexts
  module Helpers
    class Authenticate
      def call(context:)
        user = context[:current_user]
        user.nil? ? (raise GraphQL::ExecutionError, 'Authentication Error') : nil
        user.archive == true ? (raise GraphQL::ExecutionError, 'This user was archived') : nil
      end
    end

    class AuthenticateIsAdmin
      def call(user:)
        return unless user.is_admin == false

        (raise GraphQL::ExecutionError,
               "user #{user.name} does not have admin permissions")
      end
    end
  end
end

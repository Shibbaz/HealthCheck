module Services
  module Validations
    class Authenticate
      def self.call(context:)
        user = context[:current_user]
        user.nil? ? (raise GraphQL::ExecutionError, 'Authentication Error') : nil
        user.archive == true ? (raise GraphQL::ExecutionError, 'This user was archived') : nil
      end
    end
  end
end

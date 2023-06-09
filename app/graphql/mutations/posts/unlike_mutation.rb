# frozen_string_literal: true

module Mutations
  module Posts
    class UnlikeMutation < BaseMutation
      argument :id, ID, required: true
      field :status, Int, null: false
      field :error, Types::ErrorType, null: false

      def resolve(**args)
        Services::Validations::Authenticate.call(context:)
        current_user_id = context[:current_user].id
        Concepts::Posts::Repository.new.unlike(args:, current_user_id:)
        return { status: 200 }
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
end
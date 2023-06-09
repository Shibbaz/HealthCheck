#  Unliking Post mutation, Graphql script can be found in doc/graphql/mutations

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
        Error.json(e)
      end
    end
  end
end
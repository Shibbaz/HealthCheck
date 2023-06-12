# Adding Like to Post mutation, Graphql script can be found in doc/graphql/mutations

module Mutations
  module Posts
    class AddLikeMutation < BaseMutation
      argument :id, ID, required: true
      field :status, Int, null: false
      field :error, Types::ErrorType, null: false
      
      def resolve(**args)
        Services::Validations::Authenticate.call(context:)
        Concepts::Posts::Repository.new.add_like(args:, current_user_id: context[:current_user].id)
        return { status: 200 }
      rescue => e
        Error.json(e)
      end
    end
  end
end
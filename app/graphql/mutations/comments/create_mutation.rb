# Creating Comment mutation, Graphql script can be found in doc/graphql/mutations

module Mutations
  module Comments
    class CreateMutation < BaseMutation
      argument :post_id, ID, required: true
      argument :text, String, required: true
      field :error, Types::ErrorType, null: false
      field :status, Int, null: false

      def resolve(**args)
        Services::Validations::Authenticate.call(context:)
        args.merge({ user_id: context[:current_user].id })
        Concepts::Comments::Repository.new.create(args:)
        return { status: 200 }
      rescue => e
        Error.json(e)
      end
    end
  end
end

module Mutations
  module Posts
    class CreateMutation < BaseMutation
      argument :feeling, Int, required: true
      argument :question, String, required: true
      argument :text, String, required: true
      argument :visibility, Boolean, required: false, default_value: false
      field :status, Int, null: false
      field :error, Types::ErrorType, null: false

      def resolve(**args)
        Services::Validations::Authenticate.call(context:)
        args = args.merge({ user_id: context[:current_user].id })
        Concepts::Posts::Repository.new.create(args:)
        return { status: 200 }
      rescue => e
        Error.json(e)
      end
    end
  end
end
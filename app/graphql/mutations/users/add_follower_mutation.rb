module Mutations
  module Users
    class AddFollowerMutation < BaseMutation
      argument :id, ID, required: true
      field :status, Int, null: false

      def resolve(**args)
        Services::Validations::Authenticate.call(context:)
        Concepts::Users::Repository.new.add_follow(args:, current_user_id: context[:current_user].id)
        return { status: 200 }
      rescue => e
        Error.json(e)
      end
    end
  end
end
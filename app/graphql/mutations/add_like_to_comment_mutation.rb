module Mutations
  class AddLikeToCommentMutation < BaseMutation
    argument :id, ID, required: true
    field :status, Int, null: false

    def resolve(**args)
      Helpers::Authenticate.new.call(context: context)
      Contexts::Comments::Repository.new.add_like(args: args, current_user_id: context[:current_user].id)
      {status: 200}
    end
  end
end

module Mutations
  class CreateCommentMutation < BaseMutation
    argument :post_id, ID, required: true
    argument :text, String, required: true

    field :status, Int, null: false

    def resolve(**args)
      Helpers::Authenticate.new.call(context: context)
      args = args.merge({user_id: context[:current_user].id})
      Contexts::Comments::Repository.new.create(args: args)

      {status: 200}
    end
  end
end

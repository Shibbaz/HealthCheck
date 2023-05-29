module Mutations
  class UpdateCommentTextMutation < BaseMutation
    argument :id, ID, required: true
    argument :text, String, required: true
    field :status, Int, null: false

    def resolve(**args)
      Contexts::Helpers::Authenticate.new.call(context: context)
      Contexts::Comments::Repository.new.update(args: args)
      {status: 200}
    end
  end
end

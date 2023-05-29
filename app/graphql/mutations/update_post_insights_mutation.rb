module Mutations
  class UpdatePostInsightsMutation < BaseMutation
    argument :id, ID, required: true
    argument :text, String, required: true
    field :status, Int, null: false

    def resolve(**args)
      Contexts::Helpers::Authenticate.new.call(context: context)
      Contexts::Posts::Repository.new.update(args: args)
      { status: 200 }
    end
  end
end

# frozen_string_literal: true

module Mutations
  class CreatePostMutation < BaseMutation
    argument :feeling, Int, required: true
    argument :question, String, required: true
    argument :text, String, required: true

    field :status, Int, null: false

    def resolve(**args)
      Contexts::Helpers::Authenticate.new.call(context:)
      args = args.merge({ user_id: context[:current_user].id })
      Contexts::Posts::Repository.new.create(args:)

      { status: 200 }
    end
  end
end

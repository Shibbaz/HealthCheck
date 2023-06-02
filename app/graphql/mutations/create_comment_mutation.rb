# frozen_string_literal: true

module Mutations
  class CreateCommentMutation < BaseMutation
    argument :post_id, ID, required: true
    argument :text, String, required: true

    field :status, Int, null: false

    def resolve(**args)
      Services::Validations::Authenticate.call(context:)
      args = args.merge({ user_id: context[:current_user].id })
      Concepts::Comments::Repository.new.create(args:)

      { status: 200 }
    end
  end
end

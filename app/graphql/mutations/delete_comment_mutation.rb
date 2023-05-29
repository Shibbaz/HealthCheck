# frozen_string_literal: true

module Mutations
  class DeleteCommentMutation < BaseMutation
    argument :id, ID, required: true
    field :status, Int, null: false

    def resolve(**args)
      Contexts::Helpers::Authenticate.new.call(context:)
      current_user_id = context[:current_user].id
      Contexts::Comments::Repository.new.delete(args:)
      { status: 200 }
    end
  end
end

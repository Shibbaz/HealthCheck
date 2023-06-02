# frozen_string_literal: true

module Mutations
  class UnlikeCommentMutation < BaseMutation
    argument :id, ID, required: true
    field :status, Int, null: false

    def resolve(**args)
      Services::Validations::Authenticate.call(context:)
      current_user_id = context[:current_user].id
      Concepts::Comments::Repository.new.unlike(args:, current_user_id:)
      { status: 200 }
    end
  end
end

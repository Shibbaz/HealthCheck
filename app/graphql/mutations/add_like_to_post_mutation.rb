# frozen_string_literal: true

module Mutations
  class AddLikeToPostMutation < BaseMutation
    argument :id, ID, required: true
    field :status, Int, null: false

    def resolve(**args)
      Services::Authenticate.new.call(context:)
      Concepts::Posts::Repository.new.add_like(args:, current_user_id: context[:current_user].id)
      { status: 200 }
    end
  end
end

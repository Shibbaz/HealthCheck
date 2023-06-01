# frozen_string_literal: true

module Mutations
  class DeletePostMutation < BaseMutation
    argument :id, ID, required: true
    field :status, Int, null: false

    def resolve(**args)
      Services::Authenticate.new.call(context:)
      current_user_id = context[:current_user].id
      Concepts::Posts::Repository.new.delete(args:)
      { status: 200 }
    end
  end
end

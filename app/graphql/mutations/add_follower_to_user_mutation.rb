# frozen_string_literal: true

module Mutations
  class AddFollowerToUserMutation < BaseMutation
    argument :id, ID, required: true
    field :status, Int, null: false

    def resolve(**args)
      Services::Validations::Authenticate.call(context:)
      Concepts::Users::Repository.new.add_follow(args:, current_user_id: context[:current_user].id)
      return { status: 200 }
    rescue => e
      return {
        error: {
          message: e.class,
        },
        status: 404
      }
    end
  end
end

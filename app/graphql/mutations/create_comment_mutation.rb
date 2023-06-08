# frozen_string_literal: true

module Mutations
  class CreateCommentMutation < BaseMutation
    argument :post_id, ID, required: true
    argument :text, String, required: true
    field :error, Types::ErrorType, null: false
    field :status, Int, null: false

    def resolve(**args)
      Services::Validations::Authenticate.call(context:)
      args = args.merge({ user_id: context[:current_user].id })
      Concepts::Comments::Repository.new.create(args:)
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

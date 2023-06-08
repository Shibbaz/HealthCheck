# frozen_string_literal: true

module Mutations
  class UpdateCommentTextMutation < BaseMutation
    argument :id, ID, required: true
    argument :text, String, required: true
    field :status, Int, null: false
    field :error, Types::ErrorType, null: false

    def resolve(**args)
      Services::Validations::Authenticate.call(context:)
      Concepts::Comments::Repository.new.update(args:)
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

# frozen_string_literal: true

module Mutations
  class UpdateCommentTextMutation < BaseMutation
    argument :id, ID, required: true
    argument :text, String, required: true
    field :status, Int, null: false

    def resolve(**args)
      Services::Authenticate.new.call(context:)
      Contexts::Comments::Repository.new.update(args:)
      { status: 200 }
    end
  end
end

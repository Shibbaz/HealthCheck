# frozen_string_literal: true

module Mutations
  class UpdatePostInsightsMutation < BaseMutation
    argument :id, ID, required: true
    argument :text, String, required: true
    field :status, Int, null: false

    def resolve(**args)
      Services::Validations::Authenticate.call(context:)
      Concepts::Posts::Repository.new.update(args:)
      { status: 200 }
    end
  end
end

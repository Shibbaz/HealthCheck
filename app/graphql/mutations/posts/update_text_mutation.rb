# frozen_string_literal: true

module Mutations
  module Posts
    class UpdateTextMutation < BaseMutation
      argument :id, ID, required: true
      argument :text, String, required: true
      field :status, Int, null: false
      field :error, Types::ErrorType, null: false

      def resolve(**args)
        Services::Validations::Authenticate.call(context:)
        Concepts::Posts::Repository.new.update(args:)
        return { status: 200 }
      rescue => e
        Error.json(e)
      end
    end
  end
end
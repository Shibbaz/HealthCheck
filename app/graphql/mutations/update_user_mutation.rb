# frozen_string_literal: true

module Mutations
  class UpdateUserMutation < BaseMutation
    argument :email, String, required: true
    argument :password, String, required: false
    argument :name, String, required: false
    argument :phone_number, Int, required: false
    argument :gender, Int, required: false
    field :status, Int, null: false
    field :error, Types::ErrorType, null: false

    def resolve(**args)
      Services::Validations::Authenticate.call(context:)
      Concepts::Users::Repository.new.update(args:, current_user: context[:current_user])
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

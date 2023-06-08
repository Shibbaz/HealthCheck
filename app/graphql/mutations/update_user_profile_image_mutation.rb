# frozen_string_literal: true

module Mutations
  class UpdateUserProfileImageMutation < BaseMutation
    argument :file, ApolloUploadServer::Upload, required: true

    field :status, Boolean, null: false
    field :error, Types::ErrorType, null: false

    def resolve(**args)
      Services::Validations::Authenticate.call(context:)
      id = context[:current_user].id
      Concepts::Users::Repository.new.upload(id:, file: args[:file])
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

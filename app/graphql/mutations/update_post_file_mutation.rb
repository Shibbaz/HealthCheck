# frozen_string_literal: true

module Mutations
  class UpdatePostFileMutation < BaseMutation
    argument :file, ApolloUploadServer::Upload, required: true

    field :status, Boolean, null: false

    def resolve(**args)
      Services::Validations::Authenticate.call(context:)
      id = context[:current_user].id
      Concepts::Posts::Repository.new.upload(id:, file: args[:file])
      { status: 200 }
    end
  end
end

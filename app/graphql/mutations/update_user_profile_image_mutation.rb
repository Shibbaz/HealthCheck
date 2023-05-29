# frozen_string_literal: true

module Mutations
  class UpdateUserProfileImageMutation < BaseMutation
    argument :file, ApolloUploadServer::Upload, required: true

    field :status, Boolean, null: false

    def resolve(**args)
      Contexts::Helpers::Authenticate.new.call(context:)
      id = context[:current_user].id
      Contexts::Users::Repository.new.upload(id:, file: args[:file])
      { status: 200 }
    end
  end
end

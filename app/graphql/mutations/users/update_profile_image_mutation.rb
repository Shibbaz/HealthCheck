# Updating Profile Image User mutation, Graphql script can be found in doc/graphql/mutations

module Mutations
  module Users
    class UpdateProfileImageMutation < BaseMutation
      argument :file, ApolloUploadServer::Upload, required: true

      field :status, Boolean, null: false
      field :error, Types::ErrorType, null: false

      def resolve(**args)
        Services::Validations::Authenticate.call(context:)
        id = context[:current_user].id
        Concepts::Users::Repository.new.upload(id:, file: args[:file])
        return { status: 200 }
      rescue => e
        Error.json(e)
      end
    end
  end
end

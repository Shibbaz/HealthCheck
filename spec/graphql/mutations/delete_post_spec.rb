require "rails_helper"

module Mutations
  module Posts
    RSpec.describe DeletePostMutation, type: :request do
      let(:user) {
        User.create!(
          id: SecureRandom.uuid,
          name: Faker::Name.name,
          email: "test@test.com",
          password: "test",
          phone_number: 667089810
        )
      }

      let(:post) do
        Post.create(id: SecureRandom.uuid, user_id: user.id, likes: [user.id])
      end

      let(:variables) do
        {id: post.id}
      end

      let(:not_valid_variables) do
        {id: SecureRandom.uuid}
      end

      let(:token) {
        result = Mutations::SignInUserMutation.new(object: nil, field: nil, context: {session: {}}).resolve(credentials: {email: user.email, password: user.password})
        result[:token]
      }

      let(:current_user) {
        crypt = ActiveSupport::MessageEncryptor.new(Rails.application.credentials.secret_key_base.byteslice(0..31))
        tk = token
        token = crypt.decrypt_and_verify tk
        user_id = token.gsub("user-id:", "")
        user ||= User.find user_id
      }

      describe ".mutation" do
        it "returns a true" do
          HealthSchema.execute(
            query,
            variables: variables,
            context: {
              current_user: user
            }
          )

          expect {
            post.reload
          }.to raise_error(ActiveRecord::RecordNotFound)
        end

        it "not valid" do
          expect {
            HealthSchema.execute(
              query,
              variables: not_valid_variables,
              context: {
                current_user: user
              }
            )
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      def query
        <<~GQL
          mutation($id: ID!){
            deletePost(input: {id: $id}){
              clientMutationId
              status
            }
          }
        GQL
      end
    end
  end
end

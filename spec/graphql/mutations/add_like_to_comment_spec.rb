require "rails_helper"

module Mutations
  module Comments
    RSpec.describe AddLikeToCommentMutation, type: :request do
      let(:user) {
        User.create!(
          name: Faker::Name.name,
          email: "test@test.com",
          password: "test",
          phone_number: 667089810
        )
      }

      let(:post) do
        Post.create(id: SecureRandom.uuid, user_id: user.id, likes: [], insights: "Ah")
      end

      let(:comment) do
        Comment.create(id: SecureRandom.uuid, user_id: user.id, likes: [], text: "Ah", post_id: post.id)
      end

      let(:variables) do
        {id: comment.id}
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

      describe ".mutation passes" do
        it "returns a true" do
          result = HealthSchema.execute(query, variables: variables, context: {current_user: user})
          comment.reload
          expect(comment[:likes]).to eq [user.id]
        end
      end

      describe ".mutation does not pass" do
        it "not valid" do
          expect { HealthSchema.execute(query, variables: not_valid_variables, context: {current_user: user}) }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      def query
        <<~GQL
          mutation($id: ID!){
            addLikeToComment(input: {id: $id}){
              clientMutationId
              status
            }
          }
        GQL
      end
    end
  end
end

require "rails_helper"

module Mutations
  module Comments
    RSpec.describe CreateCommentMutation, type: :request do
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

      let(:variables) do
        {
          text: "XD",
          likes: [],
          post_id: post.id,
          user_id: user.id
        }
      end

      let(:not_valid_variables) do
        {
          text: "XD",
          likes: [],
          post_id: SecureRandom.uuid,
          user_id: SecureRandom.uuid
        }
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
        end
      end

      def query
        <<~GQL
            mutation($text: String!, $postId: ID!, $u){
            createComment(input: {feeling: $feeling, question: $question, likes: $likes, insigths: $insigths}){
              clientMutationId
              status
            }
          }
        GQL
      end
    end
  end
end

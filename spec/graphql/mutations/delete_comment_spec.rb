# frozen_string_literal: true

require 'rails_helper'

module Mutations
  module Comments
    RSpec.describe DeleteCommentMutation, type: :request do
      let(:user) do
        User.create!(
          id: SecureRandom.uuid,
          name: Faker::Name.name,
          email: 'test@test.com',
          password: 'test',
          phone_number: 667_089_810
        )
      end

      let(:post) do
        Post.create(id: SecureRandom.uuid, user_id: user.id, likes: [user.id])
      end

      let(:comment) do
        Comment.create(id: SecureRandom.uuid, user_id: user.id, likes: [], text: 'Ah', post_id: post.id)
      end

      let(:variables) do
        { id: comment.id }
      end

      let(:not_valid_variables) do
        { id: SecureRandom.uuid }
      end

      let(:token) do
        result = Mutations::SignInUserMutation.new(object: nil, field: nil,
                                                   context: { session: {} }).resolve(credentials: {
                                                                                       email: user.email, password: user.password
                                                                                     })
        result[:token]
      end

      let(:current_user) do
        crypt = ActiveSupport::MessageEncryptor.new(Rails.application.credentials.secret_key_base.byteslice(0..31))
        tk = token
        token = crypt.decrypt_and_verify tk
        user_id = token.gsub('user-id:', '')
        user ||= User.find user_id
        user
      end

      describe '.mutation' do
        it 'returns a true' do
          HealthSchema.execute(
            query,
            variables:,
            context: {
              current_user: user
            }
          )
          expect do
            comment.reload
          end.to raise_error(ActiveRecord::RecordNotFound)
        end

        it 'not valid' do
          expect do
            HealthSchema.execute(
              query,
              variables: not_valid_variables,
              context: {
                current_user: user
              }
            )
          end.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      def query
        <<~GQL
          mutation($id: ID!){
            deleteCommentText(input: {id: $id}){
              clientMutationId
              status
            }
          }
        GQL
      end
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

module Mutations
  module Comments
    RSpec.describe UnlikeCommentMutation, type: :request do
      let(:user) do
        create(:user)
      end

      let(:post) do
        create(:post, likes: [user.id], user_id: user.id)
      end

      let(:comment) do
        create(:comment, user_id: user.id, post_id: post.id)
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
      end

      describe '.mutation' do
        it 'returns a true' do
          HealthSchema.execute(query, variables:, context: { current_user: user })
          comment.reload
          expect(comment[:likes]).to eq []
        end

        it 'not valid' do
          mutation = HealthSchema.execute(
              query,
              variables: not_valid_variables,
              context: {
                current_user: user
              }
            )
          expect(mutation['data']['unlikeToComment']['status']).to eq 404 
          expect(mutation['data']['unlikeToComment']['error']['message']).to eq 'ActiveRecord::RecordNotFound'
        end
      end

      def query
        <<~GQL
          mutation($id: ID!){
            unlikeToComment(input: {id: $id}){
              status
              error{
                message
              }
            }
          }
        GQL
      end
    end
  end
end

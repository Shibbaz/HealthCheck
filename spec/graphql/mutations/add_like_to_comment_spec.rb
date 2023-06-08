# frozen_string_literal: true

require 'rails_helper'

module Mutations
  module Comments
    RSpec.describe AddLikeToCommentMutation, type: :request do
      let(:user) do
        create(:user)
      end

      let(:post) do
        create(:post, user_id: user.id, text: 'Ah')
      end

      let(:comment) do
        create(:comment, user_id: user.id, likes: [], text: 'Ah', post_id: post.id)
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

      describe '.mutation passes' do
        it 'returns a true' do
          HealthSchema.execute(query, variables:, context: { current_user: user })
          comment.reload
          expect(comment[:likes]).to eq [user.id]
        end
      end

      describe '.mutation does not pass' do
        it 'not valid' do
          mutation = HealthSchema.execute(query, variables: not_valid_variables, context: { current_user: user })
          expect(mutation['data']['addLikeToComment']['status']).to eq(404)
          expect(mutation['data']['addLikeToComment']['error']['message']).to eq 'ActiveRecord::RecordNotFound'
        end
      end

      def query
        <<~GQL
          mutation($id: ID!){
            addLikeToComment(input: {id: $id}){
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

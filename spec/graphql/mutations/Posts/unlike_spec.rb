# frozen_string_literal: true

require 'rails_helper'

module Mutations
  module Posts
    RSpec.describe UnlikeMutation, type: :request do
      let(:user) do
        create(:user)
      end

      let(:post) do
        create(:post, user_id: user.id, likes: [user.id])
      end

      let(:variables) do
        { id: post.id }
      end

      let(:not_valid_variables) do
        { id: SecureRandom.uuid }
      end

      let(:token) do
        result = Mutations::Users::SignInMutation.new(object: nil, field: nil,
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
          post.reload
          expect(post[:likes]).to eq []
        end

        it 'not valid' do
          mutation = HealthSchema.execute(
              query,
              variables: not_valid_variables,
              context: {
                current_user: user
              }
            )
          expect(mutation['data']['unlikeToPost']['status']).to eq 404 
          expect(mutation['data']['unlikeToPost']['error']['message']).to eq 'ActiveRecord::RecordNotFound'
        end
      end

      def query
        <<~GQL
          mutation($id: ID!){
            unlikeToPost(input: {id: $id}){
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

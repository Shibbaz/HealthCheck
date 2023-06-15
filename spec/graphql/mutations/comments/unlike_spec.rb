# frozen_string_literal: true

require 'rails_helper'

module Mutations
  module Comments
    RSpec.describe UnlikeMutation, type: :request do
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
        result = Mutations::Users::SignInMutation.new(object: nil, field: nil,
                                                   context: { ip: Faker::Internet.ip_v4_address, session: {} }).resolve(credentials: {
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

      describe 'Mutation Success' do
        it 'expects to unlike comment successfully' do
          HealthSchema.execute(query, variables:, context: { ip: Faker::Internet.ip_v4_address, current_user: user })
          comment.reload
          expect(comment[:likes]).to eq []
        end
      end

      describe 'Mutation Failure' do
        it 'expects to have invalid params' do
          mutation = HealthSchema.execute(
              query,
              variables: not_valid_variables,
              context: {
                ip: Faker::Internet.ip_v4_address,
                current_user: user
              }
            )
          expect(mutation['data']['unlikeToComment']['status']).to eq 404 
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

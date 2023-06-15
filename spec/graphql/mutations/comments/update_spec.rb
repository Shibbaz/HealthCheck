# frozen_string_literal: true

require 'rails_helper'

module Mutations
  module Comments
    RSpec.describe UpdateTextMutation, type: :request do
      let(:user) do
        create(:user)
      end

      let(:post) do
        create(:post, user_id: user.id)
      end

      let(:comment) do
        create(:comment, user_id: user.id, post_id: post.id, text: 'Ah')
      end

      let(:variables) do
        {
          id: comment.id,
          text: 'Hahaha'
        }
      end

      let(:not_valid_variables) do
        {
          id: SecureRandom.uuid,
          text: 'Hahaha'
        }
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
        user
      end

      describe 'Mutation Success' do
        it 'expects to update comment successfully' do
          HealthSchema.execute(query, variables:, context: { ip: Faker::Internet.ip_v4_address, current_user: user })
          comment.reload
          expect(comment[:text]).to eq 'Hahaha'
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
          expect(mutation['data']['updateCommentText']['status']).to eq 404 
        end
      end

      def query
        <<~GQL
          mutation($id: ID!, $text: String!){
            updateCommentText(input: {id: $id, text: $text}){
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

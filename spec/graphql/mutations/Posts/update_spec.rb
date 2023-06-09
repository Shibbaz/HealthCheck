# frozen_string_literal: true

require 'rails_helper'

module Mutations
  module Posts
    RSpec.describe UpdateTextMutation, type: :request do
      let(:user) do
        create(:user)
      end

      let(:post) do
        create(:post, user_id: user.id, text: 'Ah')
      end

      let(:variables) do
        {
          id: post.id,
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

      describe '.mutation passes' do
        it 'returns a true' do
          HealthSchema.execute(query, variables:, context: { ip: Faker::Internet.ip_v4_address, current_user: user })
          post.reload
          expect(post[:text]).to eq 'Hahaha'
        end
      end

      describe '.mutation fails' do
        it 'returns a false' do
          mutation = HealthSchema.execute(query, variables: not_valid_variables, context: { ip: Faker::Internet.ip_v4_address, current_user: user })
          expect(mutation['data']['updatePostInsights']['status']).to eq 404
          expect(mutation['data']['updatePostInsights']['error']['message']).to eq 'ActiveRecord::RecordNotFound'
        end
      end

      def query
        <<~GQL
          mutation($id: ID!, $text: String!){
            updatePostInsights(input: {id: $id, text: $text}){
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

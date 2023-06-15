# frozen_string_literal: true

require 'rails_helper'

module Mutations
  module Posts
    RSpec.describe CreateMutation, type: :request do
      let(:user) do
        create(:user)
      end

      let(:variables) do
        {
          feeling: 1,
          question: "What's up?",
          likes: [],
          text: 'it works fine'
        }
      end

      let(:not_valid_variables) do
        {
          feeling: 1,
          question: "What's up?",
          likes: [],
          text: 'it works fine'
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
        it 'expects to create post successfully' do
          HealthSchema.execute(query, variables:, context: { 
            current_user: user,
            ip: Faker::Internet.ip_v4_address
          })
        end
      end

      describe 'Mutation Failure' do
        it 'expects to not create post' do
          mutation = HealthSchema.execute(query, variables: not_valid_variables, context: { 
            ip: Faker::Internet.ip_v4_address,
            current_user: user 
          })
          expect(mutation['data']['createPost']['status']).to eq(404)
        end
      end

      def query
        <<~GQL
            mutation($feeling: Int!, $question: String! $text: String!){
            createPost(input: {feeling: $feeling, question: $question, text: $text}){
              clientMutationId
              status
            }
          }
        GQL
      end
    end
  end
end

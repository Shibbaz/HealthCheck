# frozen_string_literal: true

require 'rails_helper'

module Mutations
  module Posts
    RSpec.describe CreatePostMutation, type: :request do
      let(:user) do
        User.create!(
          name: Faker::Name.name,
          email: 'test@test.com',
          password: 'test',
          phone_number: 667_089_810
        )
      end

      let(:variables) do
        {
          feeling: 1,
          question: "What's up?",
          likes: [],
          insights: 'it works fine'
        }
      end

      let(:not_valid_variables) do
        {
          feeling: 1,
          question: "What's up?",
          likes: [],
          insights: 'it works fine'
        }
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

      describe '.mutation passes' do
        it 'returns a true' do
          HealthSchema.execute(query, variables:, context: { current_user: user })
        end
      end

      def query
        <<~GQL
            mutation($feeling: Int!, $question: String!, $likes: ID!, $insigths: String!){
            createPost(input: {feeling: $feeling, question: $question, likes: $likes, insigths: $insigths}){
              clientMutationId
              status
            }
          }
        GQL
      end
    end
  end
end

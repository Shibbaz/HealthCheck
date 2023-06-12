# frozen_string_literal: true

require 'rails_helper'

module Mutations
  module Comments
    RSpec.describe CreateMutation, type: :request do
      let(:user) do
        create(:user)
      end

      let(:post) do
        create(:post, user_id: user.id, text: 'Ah')
      end

      let(:variables) do
        {
          text: 'XD',
          likes: [],
          post_id: post.id,
          user_id: user.id
        }
      end

      let(:not_valid_variables) do
        {
          text: 'XD',
          likes: [],
          post_id: SecureRandom.uuid,
          user_id: SecureRandom.uuid
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
      end

      describe '.mutation passes' do
        it 'returns a true' do
          HealthSchema.execute(query, variables:, context: { current_user: user })
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

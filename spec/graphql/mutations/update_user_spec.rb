# frozen_string_literal: true

require 'rails_helper'

module Mutations
  module Posts
    RSpec.describe UpdateUserMutation, type: :request do
      let(:user) do
        create(:user)
      end

      let(:variables) do
        {
          email: user.email,
          password: 'testingpassword'
        }
      end

      let(:not_valid_variables) do
        {
          email: SecureRandom.uuid,
          password: 'hahaha'
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
          previous_password = user.password_digest
          HealthSchema.execute(query, variables:, context: { current_user: user })
          expect(user.password_digest).to_not eq previous_password
        end
      end

      describe '.mutation fails' do
        it 'returns a false' do
          expect do
            HealthSchema.execute(query, variables: not_valid_variables,
                                        context: { current_user: user })
          end.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      def query
        <<~GQL
          mutation($email: String!, $password: String!){
            updateUser(input: {email: $email, password: $password}){
              clientMutationId
              status
            }
          }
        GQL
      end
    end
  end
end

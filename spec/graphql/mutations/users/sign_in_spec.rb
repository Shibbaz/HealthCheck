# frozen_string_literal: true

require 'rails_helper'

module Mutations
  module Users
    module SignIn
      RSpec.describe SignInMutation, type: :request do
        describe 'Sign in' do
          describe 'Mutation Success' do
            let(:user) do
              User.create!(
                name: 'Test User',
                email: Faker::Internet.email,
                password: '[omitted]',
                phone_number: 667_089_810
              )
            end

            let(:result) do
              Mutations::Users::SignInMutation.new(object: nil, field: nil, context: { ip: Faker::Internet.ip_v4_address, session: {} }).resolve(credentials: {
                                                                                                            email: user.email,
                                                                                                            password: user.password
                                                                                                          })
            end

            it 'Mutation does pass succesful' do
              expect(result[:token].present?)
              assert_equal result[:user], user
            end
          end

          describe 'Mutation Failure' do
            let(:user) do
              User.create!(
                name: 'Test User',
                email: Faker::Internet.email,
                password: '[omitted]',
                phone_number: 667_089_810
              )
            end

            it 'expects mutation to not pass, lack of credentials' do
              not_loged_in = Mutations::Users::SignInMutation.new(object: nil, field: nil,
                                                              context: { session: {} }).resolve(credentials: {})
              assert_nil not_loged_in
            end

            it 'expects sign-in failure, wrong email' do
              not_loged_in = Mutations::Users::SignInMutation.new(object: nil, field: nil,
                                                              context: { session: {} }).resolve(credentials: { email: 'wrong' })
              assert_nil not_loged_in
            end

            it 'expects sign-in failure, wrong password' do
              not_loged_in = Mutations::Users::SignInMutation.new(object: nil, field: nil,
                                                              context: { session: {} }).resolve(credentials: {
                                                                                                  email: user.email, password: 'wrong'
                                                                                                })
              assert_nil not_loged_in
            end
          end
        end
      end
    end
  end
end
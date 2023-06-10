# frozen_string_literal: true

require 'rails_helper'

module Mutations
  module Users
    module SignIn
      RSpec.describe CreateMutation, type: :request do
        describe 'check how mutation works' do
          describe '.mutation passes' do
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

            it '.mutation does pass succesful' do
              expect(result[:token].present?)
              assert_equal result[:user], user
            end
          end

          describe '.mutation fails' do
            let(:user) do
              User.create!(
                name: 'Test User',
                email: Faker::Internet.email,
                password: '[omitted]',
                phone_number: 667_089_810
              )
            end

            it '.mutation does not pass, no credentials' do
              not_loged_in = Mutations::Users::SignInMutation.new(object: nil, field: nil,
                                                              context: { session: {} }).resolve(credentials: {})
              assert_nil not_loged_in
            end

            it 'failure because wrong email' do
              not_loged_in = Mutations::Users::SignInMutation.new(object: nil, field: nil,
                                                              context: { session: {} }).resolve(credentials: { email: 'wrong' })
              assert_nil not_loged_in
            end

            it 'failure because wrong password' do
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
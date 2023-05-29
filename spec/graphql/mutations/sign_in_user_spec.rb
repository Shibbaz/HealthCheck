require "rails_helper"

module Mutations
  module SignInUser
    RSpec.describe CreateUserMutation, type: :request do
      describe "check how mutation works" do
        describe ".mutation passes" do
          let(:user) {
            User.create!(
              name: "Test User",
              email: Faker::Internet.email,
              password: "[omitted]",
              phone_number: 667089810
            )
          }

          let(:result) {
            Mutations::SignInUserMutation.new(object: nil, field: nil, context: { session: {} }).resolve(credentials: {
                                                                                                           email: user.email,
                                                                                                           password: user.password
                                                                                                         })
          }

          it ".mutation does pass succesful" do
            expect(result[:token].present?)
            assert_equal result[:user], user
          end
        end

        describe ".mutation fails" do
          let(:user) {
            User.create!(
              name: "Test User",
              email: Faker::Internet.email,
              password: "[omitted]",
              phone_number: 667089810
            )
          }

          it ".mutation does not pass, no credentials" do
            not_loged_in = Mutations::SignInUserMutation.new(object: nil, field: nil,
                                                             context: { session: {} }).resolve(credentials: {})
            assert_nil not_loged_in
          end

          it "failure because wrong email" do
            not_loged_in = Mutations::SignInUserMutation.new(object: nil, field: nil,
                                                             context: { session: {} }).resolve(credentials: { email: "wrong" })
            assert_nil not_loged_in
          end

          it "failure because wrong password" do
            not_loged_in = Mutations::SignInUserMutation.new(object: nil, field: nil,
                                                             context: { session: {} }).resolve(credentials: {
                                                                                                 email: user.email, password: "wrong"
                                                                                               })
            assert_nil not_loged_in
          end
        end
      end
    end
  end
end

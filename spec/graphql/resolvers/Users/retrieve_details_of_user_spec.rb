
require 'rails_helper'

module Resolvers
  module Users
    RSpec.describe RetrieveDetailsOfUser, type: :request do
      describe '.resolve' do
        let(:user) do
          create(:user, name: 'John')
        end

        let(:extra_user) do
            create(:user, name: 'Sam')
        end

        let(:context) do
          GraphQL::Query::Context.new(query: OpenStruct.new(schema: HealthSchema), values: { current_user: user, ip: Faker::Internet.ip_v4_address },
                                      object: nil)
        end

        it 'returns details of user' do
          result = HealthSchema.execute(query, variables: { userId: extra_user.id }, context:)
          data = result['data']['retrieveDetailsOfUser']
          expect(data['id']).to eq(extra_user.id)
          expect(data['name']).to eq(extra_user.name)
          expect(data['email']).to eq(extra_user.email)
          expect(data['phoneNumber']).to eq(extra_user.phone_number)
        end

        it 'returns details of current user' do
          result = HealthSchema.execute(current_user_query, variables: {}, context:)
          data = result['data']['retrieveDetailsOfUser']
          expect(data['id']).to eq(user.id)
          expect(data['name']).to eq(user.name)
          expect(data['email']).to eq(user.email)
          expect(data['phoneNumber']).to eq(user.phone_number)
        end

        it 'returns details of current user' do
          id = SecureRandom.uuid
          result = HealthSchema.execute(query, variables: {userId: id}, context:)
          error_message = "Couldn't find User with 'id'="+id
          expect(result['errors'][0]["message"]).to eq(error_message)
        end

        def query
            <<~GQL
              query($userId: ID!) {
                retrieveDetailsOfUser(userId: $userId) {
                    id
                    name
                    gender
                    email
                    phoneNumber
                }
              }
            GQL
        end

        def current_user_query
          <<~GQL
            query {
              retrieveDetailsOfUser {
                  id
                  name
                  gender
                  email
                  phoneNumber
              }
            }
          GQL
        end
      end
    end
  end
end

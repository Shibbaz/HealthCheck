require "rails_helper"

module Resolvers
  module Posts
    RSpec.describe ListAllPosts, type: :request do
      describe ".resolve" do
        let(:user) {
          User.create!(
            id: SecureRandom.uuid,
            name: "test",
            email: "test@test.com",
            password: "test",
            phone_number: 667089810
          )
        }
        let(:extra_user) {
          User.create!(
            id: SecureRandom.uuid,
            name: "test2",
            email: "test2@test.com",
            password: "test2",
            phone_number: 667089810
          )
        }

        let(:extra_new_user) {
          User.create!(
            id: SecureRandom.uuid,
            name: "test3",
            email: "test3@test.com",
            password: "test3",
            phone_number: 667089810
          )
        }

        let(:context) {
          GraphQL::Query::Context.new(query: OpenStruct.new(schema: HealthSchema), values: {current_user: user}, object: nil)
        }

        before do
          Post.create(id: SecureRandom.uuid, user_id: user.id, likes: [user.id], insights: "Ah", feeling: 1)
          Post.create(id: SecureRandom.uuid, user_id: extra_user.id, likes: [], insights: "Ah", feeling: 0)
          Post.create(id: SecureRandom.uuid, user_id: extra_new_user.id, likes: [], insights: "Ah", feeling: 0)
        end

        it "returns Posts" do
          result = HealthSchema.execute(query, variables: {
            feeling: nil,
            created_at: nil,
            likes: nil,
            followers: nil
          }, context: context)
          size = result["data"]["allposts"].size
          expect(size).to eq(3)
        end

        it "filtering by feeling" do
          result = HealthSchema.execute(query, variables: {
            feeling: 1,
            created_at: nil,
            likes: nil,
            followers: nil
          }, context: context)
          size = result["data"]["allposts"].size
          expect(size).to eq(1)
        end

        it "filtering by likes" do
          result = HealthSchema.execute(query, variables: {filters: {
            likes: true,
            feeling: nil,
            created_at: nil,
            followers: nil
          }}, context: context)
          size = result["data"]["allposts"].size
          likes_counter = result["data"]["allposts"].pluck("likesCounter")
          expect(likes_counter.first > likes_counter.last).to eq(true)
          expect(size).to eq(3)
        end

        it "filtering by createdAt" do
          result = HealthSchema.execute(query, variables: {filters: {
            created_at: true,
            feeling: nil,
            likes: nil,
            followers: nil
          }}, context: context)
          size = result["data"]["allposts"].size
          dates = result["data"]["allposts"].pluck("createdAt")
          expect(Date.parse(dates.first) <= Date.parse(dates.last)).to eq(true)
          expect(size).to eq(3)
        end

        it "shows posts of user and its followers" do
          followers = [user.id, extra_user.id]
          user.update(followers: followers)
          user.reload
          result = HealthSchema.execute(query_followers, variables: {}, context: context)
          size = result["data"]["allposts"].size
          expect(size).to eq(2)
        end

        it "none found in filtering by posts" do
          result = HealthSchema.execute(query, variables: {
            feeling: 99,
            created_at: nil,
            likes: nil,
            followers: nil
          }, context: context)
          size = result["data"]["allposts"].size
          expect(size).to eq(0)
        end
      end

      def query
        <<~GQL
          query($feeling: Int, $likes: Boolean, $createdAt: Boolean, $followers: Boolean) {
              allposts(filters: {feeling: $feeling, likes: $likes, createdAt: $createdAt, followers: $followers}) {
                id
                feeling
                likesCounter
                createdAt
              }
          }
        GQL
      end

      def query_followers
        <<~GQL
          query {
            allposts(filters: {followers: true}) {
              createdAt
              feeling
              id
              likes{
                id
              }
              question
              updatedAt
            }
          }
        GQL
      end
    end
  end
end

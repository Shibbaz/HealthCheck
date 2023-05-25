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
        let(:context) {
          ctx = {
            current_user: user
          }
        }
        before do
          Post.create(id: SecureRandom.uuid, user_id: user.id, likes: [user.id], insights: "Ah", feeling: 1)
          Post.create(id: SecureRandom.uuid, user_id: user.id, likes: [], insights: "Ah", feeling: 0)
          Post.create(id: SecureRandom.uuid, user_id: user.id, likes: [], insights: "Ah", feeling: 0)
        end

        it "returns Posts" do
          result = HealthSchema.execute(query, variables: {
            feeling: nil,
            created_at: nil,
            likes: nil
          }, context: context)
          size = result["data"]["allposts"].size
          expect(size).to eq(3)
        end

        it "filtering by feeling" do
          result = HealthSchema.execute(query, variables: {
            feeling: 1,
            created_at: nil,
            likes: nil
          }, context: context)
          size = result["data"]["allposts"].size
          expect(size).to eq(1)
        end

        it "filtering by likes" do
          result = HealthSchema.execute(query, variables: {filters: {
            likes: true,
            feeling: nil,
            created_at: nil
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
            likes: nil
          }}, context: context)
          size = result["data"]["allposts"].size
          dates = result["data"]["allposts"].pluck("createdAt")
          expect(Date.parse(dates.first) <= Date.parse(dates.last)).to eq(true)
          expect(size).to eq(3)
        end

        it "none found in filtering by posts" do
          result = HealthSchema.execute(query, variables: {
            feeling: 99,
            created_at: nil,
            likes: nil
          }, context: context)
          size = result["data"]["allposts"].size
          expect(size).to eq(0)
        end
      end

      def query
        <<~GQL
          query($feeling: Int, $likes: Boolean, $createdAt: Boolean) {
              allposts(filters: {feeling: $feeling, likes: $likes, createdAt: $createdAt}) {
                id
                feeling
                likesCounter
                createdAt
              }
          }
        GQL
      end
    end
  end
end

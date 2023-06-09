# frozen_string_literal: true

require 'rails_helper'

module Resolvers
  module Posts
    RSpec.describe ListAllPosts, type: :request do
      describe '.resolve' do
        let(:user) do
          create(:user, name: 'John')
        end
        let(:extra_user) do
          create(:user, name: 'Sam', followers: [user.id])
        end

        let(:extra_new_user) do
          create(:user, name: 'Max')
        end

        let(:context) do
          GraphQL::Query::Context.new(query: OpenStruct.new(schema: HealthSchema), values: { current_user: user, ip: Faker::Internet.ip_v4_address },
                                      object: nil)
        end

        before do
          posts = [
            create(:post, user_id: user.id, likes: [user.id], text: 'Ah', feeling: 1),
            create(:post, user_id: extra_user.id, likes: [], text: 'Ah', feeling: 0),
            create(:post, user_id: extra_new_user.id, likes: [], text: 'Ah', feeling: 0),
            create(:post, user_id: extra_user.id, likes: [], text: 'Ah', feeling: 0, visibility: true)
          ]
          create(:comment, user_id: user.id, post_id: posts[0].id, text: 'test')
          create(:comment, user_id: user.id, post_id: posts[0].id, text: 'test')
          create(:comment, user_id: user.id, post_id: posts[1].id, text: 'test')
        end

        it 'returns Posts and check numbers of Comments in two posts' do
          result = HealthSchema.execute(query, variables: {
                                          feeling: nil,
                                          created_at: nil,
                                          likes: nil,
                                          followers: nil
                                        }, context:)
          first_post_comment_size = result['data']['allposts'][0]['comments'].size
          expect(first_post_comment_size).to eq(2)
          second_post_comment_size = result['data']['allposts'][1]['comments'].size
          expect(second_post_comment_size).to eq(1)
        end

        it 'returns updated versions size' do
          post = Post.last
          comment = Comment.create(id: SecureRandom.uuid, user_id: user.id, post_id: post.id, text: 'test')
          post.update(text: 'Test')
          comment.update(text: 'Test')

          result = HealthSchema.execute(query, variables: {
                                          feeling: nil,
                                          created_at: nil,
                                          likes: nil,
                                          followers: nil
                                        }, context:)

          item = result['data']['allposts'].select do |data|
            data['id'] == post.id
          end
          size = item.first['versions'].size
          expect(size).to eq(1)

          size = item.first['comments'].count do |data|
            data['id'] == comment.id
          end
          expect(size).to eq(1)

          post.update(question: 'What is my purpose?')
          comment.update(text: 'Test2')

          result = HealthSchema.execute(query, variables: {
                                          feeling: nil,
                                          created_at: nil,
                                          likes: nil,
                                          followers: nil
                                        }, context:)

          item = result['data']['allposts'].select do |data|
            data['id'] == post.id
          end
          size = item.first['versions'].size
          expect(size).to eq(2)

          size = item.first['comments'].find do |data|
            data['id'] == comment.id
          end['versions'].size
          expect(size).to eq(2)
        end

        it 'returns Posts' do
          result = HealthSchema.execute(query, variables: {
                                          feeling: nil,
                                          created_at: nil,
                                          likes: nil,
                                          followers: nil
                                        }, context:)
          size = result['data']['allposts'].size
          expect(size).to eq(4)
        end

        it 'filtering by feeling' do
          result = HealthSchema.execute(query, variables: {
                                          feeling: 1,
                                          created_at: nil,
                                          likes: nil,
                                          followers: nil
                                        }, context:)
          size = result['data']['allposts'].size
          expect(size).to eq(1)
        end

        it 'filtering by likes' do
          result = HealthSchema.execute(query, variables: { filters: {
                                          likes: true,
                                          feeling: nil,
                                          created_at: nil,
                                          followers: nil
                                        } }, context:)
          size = result['data']['allposts'].size
          likes_counter = result['data']['allposts'].pluck('likesCounter')
          expect(likes_counter.first > likes_counter.last).to eq(true)
          expect(size).to eq(4)
        end

        it 'filtering by createdAt' do
          result = HealthSchema.execute(query, variables: { filters: {
                                          created_at: true,
                                          feeling: nil,
                                          likes: nil,
                                          followers: nil
                                        } }, context:)
          size = result['data']['allposts'].size
          dates = result['data']['allposts'].pluck('createdAt')
          expect(Date.parse(dates.first) <= Date.parse(dates.last)).to eq(true)
          expect(size).to eq(4)
        end

        it 'shows posts of user and its followers' do
          followers = [user.id, extra_user.id]
          user.update(followers:)
          user.reload
          result = HealthSchema.execute(query_followers, variables: {followers: true}, context:)
          size = result['data']['allposts'].size
          expect(size).to eq(3)
        end

        it 'checks num DB queries if N+1 problem a true' do
          expect do
            HealthSchema.execute(query, variables: {}, context: { ip: Faker::Internet.ip_v4_address, current_user: user })
          end.not_to exceed_query_limit(7)
        end

        it 'none found in filtering by posts' do
          result = HealthSchema.execute(query, variables: {
                                          feeling: 99,
                                          created_at: nil,
                                          likes: nil,
                                          followers: nil
                                        }, context:)
          size = result['data']['allposts'].size
          expect(size).to eq(0)
        end

        it 'paginates the posts' do
          result = HealthSchema.execute(query, variables: {
                                          feeling: nil,
                                          created_at: nil,
                                          likes: nil,
                                          followers: nil,
                                          postPage: 1,
                                          postLimit: 1
                                        }, context:)
          size = result['data']['allposts'].size
          expect(size).to eq(1)
        end
  
        it 'paginates the comments' do
          result = HealthSchema.execute(query, variables: {
                                          feeling: nil,
                                          created_at: nil,
                                          likes: nil,
                                          followers: nil,
                                          commentPage: 1,
                                          commentLimit: 1
                                        }, context:)
          size = result['data']['allposts'][0]['comments'].size
          expect(size).to eq(1)
  
          result = HealthSchema.execute(query, variables: {
                                          feeling: nil,
                                          created_at: nil,
                                          likes: nil,
                                          followers: nil,
                                          commentPage: 1,
                                          commentLimit: 2
                                        }, context:)
          size = result['data']['allposts'][0]['comments'].size
          expect(size).to eq(2)
        end

        it 'shows vissible content' do

          extra_user.update(followers: [user.id])
          extra_user.reload
          result = HealthSchema.execute(query_user_content, variables: {
            usr: extra_user.id
                                        }, context:)
          size = result["data"]["allposts"].size
          expect(size).to eq(1)
        end
      end

      def query
        <<~GQL
          query($feeling: Int, $likes: Boolean, $createdAt: Boolean, $followers: Boolean, $postPage: Int, $postLimit: Int, $commentPage: Int, $commentLimit: Int) {
              allposts(filters: {feeling: $feeling, likes: $likes, createdAt: $createdAt, followers: $followers}, page: $postPage, limit: $postLimit) {
                id
                feeling
                likesCounter
                createdAt
                comments(page: $commentPage, limit: $commentLimit){
                  id
                  versions
                }
                versions
              }
          }
        GQL
      end

      def query_followers
        <<~GQL
          query($followers: Boolean) {
            allposts(filters: {followers: $followers}) {
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

      def query_user_content
        <<~GQL
          query($usr: ID!) {
            allposts(usr: $usr, filters: {}) {
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

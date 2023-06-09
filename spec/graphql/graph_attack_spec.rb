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


          it 'checks if graphattack' do
            @result = nil
            (1..14).step(1) do |n|
                @result = HealthSchema.execute(query, variables: {
                                            feeling: nil,
                                            created_at: nil,
                                            likes: nil,
                                            followers: nil
                                        }, context:)
            end
            data = @result["data"]["allposts"]
            expect(data.size).to be(4)
          end

          it 'checks if graphattack' do
            @result = nil
            (1..15).step(1) do |n|
                @result = HealthSchema.execute(query, variables: {
                                            feeling: nil,
                                            created_at: nil,
                                            likes: nil,
                                            followers: nil
                                        }, context:)
                end
            error_type = @result["errors"][0]["message"].to_s
            expect(error_type).to eq("Query rate limit exceeded")
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
        end
    end
end
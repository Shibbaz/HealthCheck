module Contexts
  module Posts
    module Commands
      class UpdatePost
        def call(event)
          stream = event.data
          post = stream[:adapter].find(stream[:id])
          post.with_lock do
            update(post: post, insights: stream[:insights])
          end
        end

        private

        def update(post:, insights:)
          post.update(insights: insights)
        end
      end
    end
  end
end

module Contexts
  module Posts
    module Commands
      class UpdatePost
        def call(event)
          stream = event.data
          post = stream[:adapter].find(stream[:id])
          update(post: post, insights: stream[:insights])
        end

        private

        def update(post:, insights:)
          post.update(insights: insights)
        end
      end
    end
  end
end

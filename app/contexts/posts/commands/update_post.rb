module Contexts
  module Posts
    module Commands
      class UpdatePost
        def call(event)
          stream = event.data
          post = Contexts::Helpers::Records.load(
            adapter: stream[:adapter],
            id: stream[:id]
          )
          post.nil? ? (raise Contexts::Posts::Errors::PostNotFoundError.new) : nil
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

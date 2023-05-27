module Contexts
  module Posts
    module Commands
      class DeletePost
        def call(event)
          stream = event.data
          post = Contexts::Helpers::Records.load(
            adapter: stream[:adapter],
            id: stream[:id]
          )
          post.nil? ? (raise Contexts::Posts::Errors::PostNotFoundError.new) : nil
          post.with_lock do
            post.destroy
          end
        end
      end
    end
  end
end

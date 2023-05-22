module Contexts
  module Posts
    module Commands
      class DeletePost
        def call(event)
          stream = event.data
          post = stream[:adapter].find(stream[:id])
          post.with_lock do
            post.destroy()
          end
        end
      end
    end
  end
end

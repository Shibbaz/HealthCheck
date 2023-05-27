module Contexts
  module Posts
    module Commands
      class AddLikeToPost
        def call(event)
          data = stream_data(event)
          post = Contexts::Helpers::Records.load(
            adapter: data[:adapter],
            id: data[:id]
          )
          post.nil? ? (raise ActiveRecord::RecordNotFound, "Post not found Error") : nil
          array = (post.likes.uniq + [data[:current_user_id]].uniq)
          post.with_lock do
            post.update(likes: array)
          end
        end

        private

        def stream_data(event)
          stream = event.data
          {
            id: stream[:id],
            current_user_id: stream[:current_user_id],
            adapter: stream[:adapter]
          }
        end
      end
    end
  end
end

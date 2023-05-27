module Contexts
  module Posts
    module Commands
      class UnlikePost
        def call(event)
          stream = event.data
          post_id = stream[:id]
          adapter = stream[:adapter]
          current_user_id = stream[:current_user_id]
          post = Contexts::Helpers::Records.load(
            adapter: stream[:adapter],
            id: post_id
          )
          post.nil? ? (raise Contexts::Posts::Errors::PostNotFoundError.new) : nil
          post.with_lock do
            post.likes.include? current_user_id ? post.update(likes: (post.likes.uniq - [current_user_id].uniq).uniq) : (raise GraphQL::ExecutionError, "User not exists in like array")
          end
        end
      end
    end
  end
end

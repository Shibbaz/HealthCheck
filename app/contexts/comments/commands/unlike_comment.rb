module Contexts
  module Comments
    module Commands
      class UnlikeComment
        def call(event)
          stream = event.data
          comment_id = stream[:id]
          adapter = stream[:adapter]
          current_user_id = stream[:current_user_id]
          comment = adapter.find comment_id
          comment.nil? ? (raise ActiveRecord::RecordNotFound, "Post not found Error") : nil
          comment.with_lock do
            comment.likes.include? current_user_id ? comment.update(likes: (comment.likes.uniq - [current_user_id].uniq).uniq) : (raise GraphQL::ExecutionError, "User not exists in like array")
          end
        end
      end
    end
  end
end

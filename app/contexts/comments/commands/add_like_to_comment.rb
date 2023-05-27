module Contexts
  module Comments
    module Commands
      class AddLikeToComment
        def call(event)
          data = stream_data(event)
          comment = Contexts::Helpers::Records.load(
            adapter: data[:adapter],
            id: data[:id]
          )
          comment.nil? ? (raise Contexts::Comments::Errors::CommentNotFoundError.new) : nil

          likes = comment.likes.uniq
          array = (likes + [data[:current_user_id]].uniq)
          comment.with_lock do
            comment.update(likes: array)
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

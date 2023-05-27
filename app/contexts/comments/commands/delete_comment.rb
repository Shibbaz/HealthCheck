module Contexts
  module Comments
    module Commands
      class DeleteComment
        def call(event)
          stream = event.data
          comment = Contexts::Helpers::Records.load(
            adapter: stream[:adapter],
            id: stream[:id]
          )
          comment.nil? ? (raise Contexts::Comments::Errors::CommentNotFoundError.new) : nil
          comment.with_lock do
            comment.destroy
          end
        end
      end
    end
  end
end

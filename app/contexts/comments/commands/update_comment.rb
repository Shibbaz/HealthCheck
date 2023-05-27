module Contexts
  module Comments
    module Commands
      class UpdateComment
        def call(event)
          stream = event.data
          comment = Contexts::Helpers::Records.load(
            adapter: stream[:adapter],
            id: stream[:id]
          )
          comment.nil? ? (raise ActiveRecord::RecordNotFound, "Comment not found Error") : nil

          comment.with_lock do
            update(comment: comment, text: stream[:text])
          end
        end

        private

        def update(comment:, text:)
          comment.update(text: text)
        end
      end
    end
  end
end

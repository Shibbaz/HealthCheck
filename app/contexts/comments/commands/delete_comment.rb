module Contexts
  module Comments
    module Commands
      class DeleteComment
        def call(event)
          stream = event.data
          comment = stream[:adapter].find(stream[:id])
          comment.with_lock do
            comment.destroy
          end
        end
      end
    end
  end
end

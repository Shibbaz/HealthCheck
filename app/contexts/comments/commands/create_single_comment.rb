module Contexts
  module Comments
    module Commands
      class CreateSingleComment
        def call(event)
          stream = event.data
          stream[:adapter].create!(
            user_id: stream[:user_id],
            text: stream[:text],
            post_id: stream[:post_id]
          )
        end
      end
    end
  end
end

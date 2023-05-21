module Contexts
  module Posts
    module Commands
      class CreateSinglePost
        def call(event)
          stream = event.data
          user = stream[:adapter].create!(
            user_id: stream[:user_id],
            insights: stream[:insights],
            feeling: stream[:feeling]
          )
        end
      end
    end
  end
end

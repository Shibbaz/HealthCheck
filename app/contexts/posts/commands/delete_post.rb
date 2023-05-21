module Contexts
  module Posts
    module Commands
      class DeletePost
        def call(event)
          stream = event.data
          stream[:adapter].find(stream[:id]).destroy()
        end
      end
    end
  end
end

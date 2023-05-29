module Contexts
  module Records
    module Commands
      class CreateRecord
        def call(event)
          stream = event.data
          stream[:adapter].create!(
            stream[:args]
          )
        end
      end
    end
  end
end

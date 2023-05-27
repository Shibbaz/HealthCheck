module Contexts
  module Records
    module Commands
      class DeleteRecord
        def call(event)
          stream = event.data
          error_type = Contexts::Helpers::Records.build_error(adapter: stream[:adapter])

          comment = Contexts::Helpers::Records.load(
            adapter: stream[:adapter],
            id: stream[:id]
          )
          comment.nil? ? (raise error_type.new) : nil
          comment.with_lock do
            comment.destroy
          end
        end
      end
    end
  end
end

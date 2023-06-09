# CRUD Concepts commands are reused in other concepts.

module Concepts
  module Records
    module Commands
      class DeleteRecord
        def call(event)
          stream = event.data
          record = Services::Records.load(
            adapter: stream[:adapter],
            id: stream[:id]
          )
          Error.raise(record)
          record.with_lock do
            record.destroy
          end
        end
      end
    end
  end
end

# frozen_string_literal: true

module Concepts
  module Records
    module Commands
      class DeleteRecord
        def call(event)
          stream = event.data
          error_type = Services::Records.build_error(adapter: stream[:adapter])

          record = Services::Records.load(
            adapter: stream[:adapter],
            id: stream[:id]
          )
          record.nil? ? (raise error_type) : nil
          record.with_lock do
            record.destroy
          end
        end
      end
    end
  end
end

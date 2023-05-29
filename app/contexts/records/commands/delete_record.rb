# frozen_string_literal: true

module Contexts
  module Records
    module Commands
      class DeleteRecord
        def call(event)
          stream = event.data
          error_type = Contexts::Helpers::Records.build_error(adapter: stream[:adapter])

          record = Contexts::Helpers::Records.load(
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

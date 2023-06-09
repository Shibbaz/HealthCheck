# frozen_string_literal: true

module Concepts
  module Records
    module Commands
      class UpdateRecord
        def call(event)
          stream = event.data
          record = Services::Records.load(
            adapter: stream[:adapter],
            id: stream[:id]
          )
          Error.raise(record)
          record.with_lock do
            record.text = stream[:text]
            record.save!
          end
        end
      end
    end
  end
end

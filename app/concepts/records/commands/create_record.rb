# frozen_string_literal: true

module Concepts
  module Records
    module Commands
      class CreateRecord
        def call(event)
          stream = event.data
          adapter = stream[:adapter]
          record ||= adapter.create!(
            stream[:args]
          )
          args = args.merge({ record: record })
          Concepts::Notifications::Repository.new.notificationOnComment(
            adapter: adapter, 
            record: record, 
            id: stream[:args][:id], 
            current_user_id: stream[:adapter][current_user_id]
            )

        end
      end
    end
  end
end
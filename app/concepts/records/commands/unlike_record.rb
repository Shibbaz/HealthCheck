# CRUD Concepts commands are reused in other concepts.

module Concepts
  module Records
    module Commands
      class UnlikeRecord
        def call(event)
          stream = event.data
          id = stream[:id]
          adapter = stream[:adapter]
          current_user_id = stream[:current_user_id]
          record = Services::Records.load(
            adapter:,
            id:
          )
          Error.raise(record)
          record.with_lock do
            record.likes.delete(current_user_id)
            record.likes.include? current_user_id ? record.save! : (raise GraphQL::ExecutionError,
                                                                                                                                     'User not exists in like array')
          end
        end
      end
    end
  end
end

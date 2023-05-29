# frozen_string_literal: true

module Contexts
  module Records
    module Commands
      class UnlikeRecord
        def call(event)
          stream = event.data
          error_type = Contexts::Helpers::Records.build_error(adapter: stream[:adapter])
          id = stream[:id]
          adapter = stream[:adapter]
          current_user_id = stream[:current_user_id]
          record = Contexts::Helpers::Records.load(
            adapter:,
            id:
          )
          record.nil? ? (raise error_type) : nil
          record.with_lock do
            record.likes.include? current_user_id ? record.update(likes: (record.likes.uniq - [current_user_id].uniq).uniq) : (raise GraphQL::ExecutionError,
                                                                                                                                     'User not exists in like array')
          end
        end
      end
    end
  end
end

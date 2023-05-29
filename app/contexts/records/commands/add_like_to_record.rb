# frozen_string_literal: true

module Contexts
  module Records
    module Commands
      class AddLikeToRecord
        def call(event)
          data = stream_data(event)
          error_type = Contexts::Helpers::Records.build_error(adapter: data[:adapter])
          record = Contexts::Helpers::Records.load(
            adapter: data[:adapter],
            id: data[:id]
          )
          record.nil? ? (raise error_type) : nil

          likes = record.likes.uniq
          array = (likes + [data[:current_user_id]].uniq)
          record.with_lock do
            record.update(likes: array)
          end
        end

        private

        def stream_data(event)
          stream = event.data
          {
            id: stream[:id],
            current_user_id: stream[:current_user_id],
            adapter: stream[:adapter]
          }
        end
      end
    end
  end
end

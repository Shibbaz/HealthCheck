# frozen_string_literal: true

module Concepts
  module Records
    module Commands
      class AddLikeToRecord
        def call(event)
          data = stream_data(event)
          error_type = Services::Records.build_error(adapter: data[:adapter])
          record = Services::Records.load(
            adapter: data[:adapter],
            id: data[:id]
          )
          record.nil? ? (raise error_type) : nil

          likes = record.likes.uniq
          current_user_id = data[:current_user_id]
          array = (likes + [current_user_id].uniq).uniq
          return if likes == array

          record.with_lock do
            record.update(likes: array)
            Concepts::Notifications::Repository.new.notificationOnLike(
              record:,
              current_user_id:
            )
            if record.user_id != current_user_id
              Services::Suggestions.create(
                receiver_id: record.user_id,
                author_id: current_user_id
              )
            end
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

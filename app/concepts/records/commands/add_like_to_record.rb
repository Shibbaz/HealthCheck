# CRUD Concepts commands are reused in other concepts.

module Concepts
  module Records
    module Commands
      class AddLikeToRecord
        def call(event)
          data = stream_data(event)
          record = Services::Records.load(
            adapter: data[:adapter],
            id: data[:id]
          )
          Error.raise(record)
          likes = record.likes.dup
          current_user_id = data[:current_user_id]
          return if likes.equal? record.likes
          record.with_lock do
            record.likes = record.likes.concat([current_user_id])
            record.save!
            record.reload
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

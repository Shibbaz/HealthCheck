# Adding Follower to Current User by User ID

module Concepts
  module Users
    module Commands
      class AddFollowerToUser
        def call(event)
          data = stream_data(event)
          record = Services::Records.load(
            adapter: data[:adapter],
            id: data[:id]
          )
          Error.raise(record)

          followers = record.followers.dup
          current_user_id = data[:current_user_id]

          record.followers.concat([current_user_id])
          return if followers == record.followers

          record.with_lock do
            record.save!
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

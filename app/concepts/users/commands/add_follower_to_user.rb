# frozen_string_literal: true

module Concepts
  module Users
    module Commands
      class AddFollowerToUser
        def call(event)
          data = stream_data(event)
          error_type = Services::Records.build_error(adapter: data[:adapter])
          record = Services::Records.load(
            adapter: data[:adapter],
            id: data[:id]
          )
          record.nil? ? (raise error_type) : nil

          followers = record.followers.uniq
          current_user_id = data[:current_user_id]
          array = (followers + [current_user_id].uniq).uniq
          return if followers == array

          record.with_lock do
            record.update(followers: array)
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

# frozen_string_literal: true

module Contexts
  module Records
    module Commands
      class CreateRecord
        def call(event)
          stream = event.data
          record ||= stream[:adapter].create!(
            stream[:args]
          )
          if record != nil && stream[:adapter].eql?(Comment)
            post = Post.find stream[:args][:post_id]
            Notification.create(
              activity: "Comment", 
              destination_id: stream[:args][:post_id],
              adapter: stream[:adapter].to_s, 
              author_id: stream[:current_user_id],
              receiver_id: post.user_id
            )
          end
        end
      end
    end
  end
end

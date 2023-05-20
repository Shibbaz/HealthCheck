module Contexts
    module Posts
      module Commands
        class AddLikeToPost
          def call(event)
            data = stream_data(event)
            post = data[:adapter].find data[:id]
            array = (post.likes.uniq + [data[:current_user_id]].uniq)
            post.update(likes: array)
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
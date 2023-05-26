module Contexts
  module Comments
    class Repository
      attr_reader :adapter

      def initialize(adapter: Comment)
        @adapter = adapter
      end

      def create_comment(args:)
        event = CommentWasCreated.new(data: {
          text: args[:text],
          user_id: args[:user_id],
          post_id: args[:post_id],
          adapter: @adapter
        })
        $event_store.publish(event, stream_name: SecureRandom.uuid)
      end

      def add_like(args:, current_user_id:)
        event = CommentWasLiked.new(data: {
          id: args[:id],
          current_user_id: current_user_id,
          adapter: @adapter
        })
        $event_store.publish(event, stream_name: SecureRandom.uuid)
      end

      def update(args:)
        event = CommentWasUpdated.new(data: {
          adapter: @adapter,
          id: args[:id],
          text: args[:text]
        })
        $event_store.publish(event, stream_name: SecureRandom.uuid)
      end

      def unlike(args:, current_user_id:)
        event = CommentWasUnliked.new(data: {
          adapter: @adapter,
          id: args[:id],
          current_user_id: current_user_id
        })
        $event_store.publish(event, stream_name: SecureRandom.uuid)
      end

      def delete(args:)
        event = CommentWasDeleted.new(data: {
          adapter: @adapter,
          id: args[:id]
        })
        $event_store.publish(event, stream_name: SecureRandom.uuid)
      end
    end
  end
end

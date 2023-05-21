module Contexts
  module Posts
    class Repository
      attr_reader :adapter

      def initialize(adapter: Post)
        @adapter = adapter
      end

      def create_post(args:)
        event = PostWasCreated.new(data: {
          user_id: args[:user_id],
          insights: args[:insights],
          feeling: args[:feeling],
          adapter: @adapter
        })
        $event_store.publish(event, stream_name: SecureRandom.uuid)
      end

      def add_like(args:, current_user_id:)
        event = PostWasLiked.new(data: {
          id: args[:id],
          current_user_id: current_user_id,
          adapter: @adapter
        })
        $event_store.publish(event, stream_name: SecureRandom.uuid)
      end

      def update(args:)
        event = PostWasUpdated.new(data: {
          adapter: @adapter,
          id: args[:id],
          insights: args[:insights]
        })
        $event_store.publish(event, stream_name: SecureRandom.uuid)
      end

      def unlike(args:, current_user_id:)
        event = PostWasUnliked.new(data: {
          adapter: @adapter,
          id: args[:id],
          current_user_id: current_user_id
        })
        $event_store.publish(event, stream_name: SecureRandom.uuid)
      end

      def delete(args:)
        event = PostWasDeleted.new(data: {
          adapter: @adapter,
          id: args[:id]
        })
        $event_store.publish(event, stream_name: SecureRandom.uuid)
      end
    end
  end
end

module Contexts
  module Posts
    class Repository
      attr_reader :adapter

      def initialize(adapter: Post)
        @adapter = adapter
      end

      def create_post(user_id:, insights:, feeling:)
        event = PostWasCreated.new(data: {
          user_id: user_id,
          insights: insights,
          feeling: feeling,
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

      def unlike(args:, current_user_id:)
        event = PostWasUnliked.new(data: {
                                       adapter: @adapter,
                                       id: args[:id],
                                       current_user_id: current_user_id
                                     })
        $event_store.publish(event, stream_name: SecureRandom.uuid)
      end
    end
  end
end

module Contexts
  module Records
    class Repository
      attr_reader :adapter

      def initialize(adapter:)
        @adapter = adapter
      end

      def create(args:)
        event_type = Contexts::Helpers::Records.build_event(adapter: adapter, event_type: "Created")

        event = event_type.new(data: {
          params: {
            text: args[:text]
          },
          user_id: args[:user_id],
          post_id: args[:post_id],
          adapter: @adapter
        })
        $event_store.publish(event, stream_name: SecureRandom.uuid)
      end

      def add_like(args:, current_user_id:)
        event_type = Contexts::Helpers::Records.build_event(adapter: adapter, event_type: "Liked")
        event = event_type.new(data: {
          id: args[:id],
          current_user_id: current_user_id,
          adapter: @adapter
        })
        $event_store.publish(event, stream_name: SecureRandom.uuid)
      end

      def update(args:)
        event_type = Contexts::Helpers::Records.build_event(adapter: adapter, event_type: "Updated")
        event = event_type.new(data: {
          adapter: @adapter,
          id: args[:id],
          text: args[:text]
        })
        $event_store.publish(event, stream_name: SecureRandom.uuid)
      end

      def unlike(args:, current_user_id:)
        event_name = "#{@adapter}WasUnliked"
        event_type = event_name.constantize
        event = event_type.new(data: {
          adapter: @adapter,
          id: args[:id],
          current_user_id: current_user_id
        })
        $event_store.publish(event, stream_name: SecureRandom.uuid)
      end

      def delete(args:)
        event_name = "#{@adapter}WasDeleted"
        event_type = event_name.constantize
        event = event_type.new(data: {
          adapter: @adapter,
          id: args[:id]
        })
        $event_store.publish(event, stream_name: SecureRandom.uuid)
      end
    end
  end
end

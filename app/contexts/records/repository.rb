# frozen_string_literal: true

module Contexts
  module Records
    class Repository
      attr_reader :adapter

      def initialize(adapter:)
        @adapter = adapter
      end

      def create(args:)
        event_type = Services::Records.build_event(adapter:, event_type: 'Created')
        data = {
          args:,
          adapter: @adapter
        }
        Contexts::Events::Publish.call(data: data, event_type: event_type)
      end

      def add_like(args:, current_user_id:)
        event_type = Services::Records.build_event(adapter:, event_type: 'Liked')
        data = {
          id: args[:id],
          current_user_id:,
          adapter: @adapter
        }
        Contexts::Events::Publish.call(data: data, event_type: event_type)
      end

      def update(args:)
        event_type = Services::Records.build_event(adapter:, event_type: 'Updated')
        data =  {
          adapter: @adapter,
          id: args[:id],
          text: args[:text]
        }
        Contexts::Events::Publish.call(data: data, event_type: event_type)
      end

      def unlike(args:, current_user_id:)
        event_type = Services::Records.build_event(adapter:, event_type: 'Unliked')
        data = {
          adapter: @adapter,
          id: args[:id],
          current_user_id:
        }
        Contexts::Events::Publish.call(data: data, event_type: event_type)
      end

      def delete(args:)
        event_type = Services::Records.build_event(adapter:, event_type: 'Deleted')
        data = {
          adapter: @adapter,
          id: args[:id]
        }
        Contexts::Events::Publish.call(data: data, event_type: event_type)
      end
    end
  end
end

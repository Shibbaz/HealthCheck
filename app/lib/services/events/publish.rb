module Services
  module Events
    class Publish
      def self.call(event_type:, data: {})
        event = event_type.new(data:)
        Rails.configuration.event_store.publish(event, stream_name: SecureRandom.uuid)
      end
    end
  end
end

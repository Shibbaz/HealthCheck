module Contexts
    module Events
        class Publish
            def self.call(data: {}, event_type:)
                event = event_type.new(data: data)
                Rails.configuration.event_store.publish(event, stream_name: SecureRandom.uuid)
            end
        end
    end
end

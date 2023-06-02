module Services
    module Events
        class Subscribe
            def self.call(event_store: Rails.configuration.event_store, events: {})
                events.each { |command, event|
                    event_store.subscribe(command.new, to: [event])
                }
            end
        end
    end
end
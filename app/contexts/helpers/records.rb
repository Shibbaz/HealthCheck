module Contexts
  module Helpers
    class Records
      def self.build_error(adapter:)
        error_name = "Contexts::#{adapter}s::Errors::#{adapter}NotFoundError"
        error_type = error_name.constantize
      end

      def self.build_event(adapter:, event_type:)
        event_name = "#{adapter}Was#{event_type}"
        event_type = event_name.constantize
      end

      def self.load(adapter:, id:)
        BatchLoader.for(id).batch do |ids, loader|
          adapter.where(id: ids).each { |object| loader.call(object.id, object) }
        end
      end

      def self.load_array(adapter:, array:)
        BatchLoader.for(array).batch(default_value: []) do |object_ids, loader|
          adapter.where(id: object_ids).each { |object|
            loader.call(array) { |memo| memo << object }
          }
        end
      end
    end
  end
end

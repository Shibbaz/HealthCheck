module Types
  module Concepts
    class NotificationType < Types::Base::Object
      field :id, ID, null: false
      field :activity, String, null: false
      field :adapter, String, null: false
      field :author_id, ID, null: false
      field :receiver_id, ID, null: false
      field :destination_id, ID, null: false

      def id
        cache_fragment(object_cache_key: "notification_id", expires_in: 1.hour) { object.id }
      end

      def activity
        cache_fragment(object_cache_key: "notification_activity", expires_in: 1.hour) {
          object.activity
        }
      end

      def adapter
        cache_fragment(object_cache_key: "notification_adapter", expires_in: 1.hour) {
          object.adapter
        }
      end

      def author_id
        cache_fragment(object_cache_key: "notification_author_id", expires_in: 1.hour) {
          object.author_id
        }
      end
      
      def receiver_id
        cache_fragment(object_cache_key: "notification_receiver_id", expires_in: 1.hour) {
          object.receiver_id
        }
      end

      def destination_id
        cache_fragment(object_cache_key: "notification_destination_id", expires_in: 1.hour) {
          object.destination_id
        }
      end
    end
  end
end

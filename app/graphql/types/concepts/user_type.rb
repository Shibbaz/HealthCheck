module Types
  module Concepts
    class Concepts::UserType < Types::Base::Object
      field :id, ID, cache_fragment: true, null: false
      field :name, String, null: false
      field :email, String, null: false
      field :phone_number, Int, null: false
      field :gender, String, null: false

      def email
        cache_fragment(object_cache_key: "user_email", expires_in: 5.minutes) { object.email }
      end

      def id
        cache_fragment(object_cache_key: "user_id", expires_in: 5.minutes) { object.id }
      end

      def phone_number
        cache_fragment(object_cache_key: "user_phone_number", expires_in: 5.minutes) {
          object.phone_number
        }
      end

      def gender
        cache_fragment(object_cache_key: "user_gender", expires_in: 5.minutes) {
          case object.gender
          when 0
            'man'
          else
            'woman'
          end
        }
      end
    end
  end
end
module Types
  module Concepts
    class Concepts::CommentType < Types::Concepts::RecordType
      field :id, ID, null: false
      field :text, String, null: false

      def id
        cache_fragment(object_cache_key: "comment_id", expires_in: 1.hour) { object.id }
      end

      def text
        cache_fragment(object_cache_key: "comment_text", expires_in: 1.hour) { object.text }
      end
    end
  end
end
module Types
  module Concepts
    class Concepts::PostType < Types::Concepts::RecordType
      field :id, ID, null: false
      field :text, String, null: false
      field :question, String, null: false
      field :feeling, Int, null: false
      field :comments, [Types::Concepts::CommentType], null: false do
        argument :page, Integer, required: false
        argument :limit, Integer, required: false
      end
    
      def comments(page: nil, limit: nil)
        cache_fragment(object_cache_key: "post_comments", expires_in: 5.minutes) {
          object.comments.page(page).per(limit)
        }
      end

      def id
        cache_fragment(object_cache_key: "post_id", expires_in: 5.minutes) { object.id }
      end

      def text
        cache_fragment(object_cache_key: "post_text", expires_in: 5.minutes) { object.text }
      end

      def question
        cache_fragment(object_cache_key: "post_question", expires_in: 5.minutes) { object.question }
      end

      def feeling
        cache_fragment(object_cache_key: "post_feeling", expires_in: 5.minutes) { object.feeling }
      end
    end
  end
end

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
        outer_path = context.namespace(:interpreter)[:current_path]
        comment_ids = object.comment_ids[(page-1) * limit..limit]
        Services::Records.for(Comment).load_many(comment_ids) do |comment|
          context.namespace(:interpreter)[:current_path] = outer_path
          cache_fragment(comment, context: context)
        end
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

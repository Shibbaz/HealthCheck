# frozen_string_literal: true

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
        object.comments.page(page).per(limit)
      end
    end
  end
end

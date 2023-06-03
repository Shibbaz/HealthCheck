# frozen_string_literal: true

module Types
  class PostType < Types::RecordType
    field :id, ID, null: false
    field :text, String, null: false
    field :question, String, null: false
    field :feeling, Int, null: false
    field :comments, [Types::CommentType], null: false

    def comments
      object.comments
    end
  end
end

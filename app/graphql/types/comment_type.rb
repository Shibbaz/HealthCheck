# frozen_string_literal: true

module Types
  class CommentType < Types::RecordType
    field :id, ID, null: false
    field :text, String, null: false
  end
end

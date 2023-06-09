# frozen_string_literal: true

module Types
  module Concepts
    class Concepts::CommentType < Types::Concepts::RecordType
      field :id, ID, null: false
      field :text, String, null: false
    end
  end
end
# frozen_string_literal: true

module Concepts
  module Comments
    module Errors
      class CommentNotFoundError < ActiveRecord::RecordNotFound
        def message
          'Comment is not found'
        end
      end
    end
  end
end

# frozen_string_literal: true

module Contexts
  module Posts
    module Errors
      class PostNotFoundError < ActiveRecord::RecordNotFound
        def message
          'Post is not found'
        end
      end
    end
  end
end

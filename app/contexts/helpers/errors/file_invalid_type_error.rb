# frozen_string_literal: true

module Contexts
  module Helpers
    module Errors
      class FileInvalidTypeError < ActiveRecord::RecordNotFound
        def message
          'File is not found'
        end
      end
    end
  end
end

# frozen_string_literal: true

module Concepts
  module Records
    module Errors
      class RecordNotFoundError < ActiveRecord::RecordNotFound
        def message
          'Record is not found'
        end
      end
    end
  end
end

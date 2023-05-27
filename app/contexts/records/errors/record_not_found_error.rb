module Contexts
  module Records
    module Errors
      class RecordNotFoundError < ActiveRecord::RecordNotFound
        def message
          "Record is not found"
        end
      end
    end
  end
end

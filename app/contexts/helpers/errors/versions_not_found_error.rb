module Contexts
  module Helpers
    module Errors
      class VersionsNotFoundError < ActiveRecord::RecordNotFound
        def message
          "Versions are not found"
        end
      end
    end
  end
end

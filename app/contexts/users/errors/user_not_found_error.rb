module Context
  module Routes
    module Errors
      class UserNotFoundError < ActiveRecord::RecordNotFound
        def message
          "User is not found"
        end
      end
    end
  end
end

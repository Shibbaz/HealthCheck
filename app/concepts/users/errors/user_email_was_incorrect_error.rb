module Concepts
  module Users
    module Errors
      class UserEmailWasIncorrectError < ActiveRecord::RecordNotFound
        def message
          'User email was incorrect!'
        end
      end
    end
  end
end

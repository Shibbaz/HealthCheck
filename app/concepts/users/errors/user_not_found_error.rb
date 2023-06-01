# frozen_string_literal: true

module Concepts
  module Users
    module Errors
      class UserNotFoundError < ActiveRecord::RecordNotFound
        def message
          'User is not found'
        end
      end
    end
  end
end

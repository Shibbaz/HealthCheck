# frozen_string_literal: true

module Concepts
  module Users
    module Queries
      class Details
        def call(args:, context:)
          id = args[:user_id].nil? ? context[:current_user].id : args[:user_id]
          User.find id
        end
      end
    end
  end
end

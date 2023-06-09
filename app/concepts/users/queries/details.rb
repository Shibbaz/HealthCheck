# frozen_string_literal: true

module Concepts
  module Users
    module Queries
      class Details
        def call(args:, context:)
          id = args[:user_id].nil? ? context[:current_user].id : args[:user_id]
          user = User.find id
          {
            id: user.id,
            name: user.name,
            email: user.email,
            phone_number: user.phone_number
            gender: user.gender
          }
        end
      end
    end
  end
end

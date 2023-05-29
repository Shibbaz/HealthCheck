# frozen_string_literal: true

module Mutations
  class UnlikePostMutation < BaseMutation
    argument :id, ID, required: true
    field :status, Int, null: false

    def resolve(**args)
      Contexts::Helpers::Authenticate.new.call(context:)
      current_user_id = context[:current_user].id
      Contexts::Posts::Repository.new.unlike(args:, current_user_id:)
      { status: 200 }
    end
  end
end

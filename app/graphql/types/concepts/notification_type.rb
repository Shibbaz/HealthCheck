module Types
  module Concepts
    class NotificationType < Types::Base::Object
      field :id, ID, null: false
      field :activity, String, null: false
      field :adapter, String, null: false
      field :author_id, ID, null: false
      field :receiver_id, ID, null: false
      field :destination_id, ID, null: false
    end
  end
end

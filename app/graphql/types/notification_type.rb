module Types
    class NotificationType < Types::BaseObject
        field :id, ID, null: false
        field :activity, String, null: false
        field :adapter, String, null: false
        field :author_id, ID, null: false
        field :receiver_id, ID, null: false
        field :destination_id, ID, null: false
    end
end
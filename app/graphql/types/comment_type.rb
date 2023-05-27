module Types
  class CommentType < Types::BaseObject
    field :id, ID, null: false
    field :text, String, null: false
    field :likes, [Types::UserType], null: false
    field :likes_counter, Int, null: false
    field :versions, [GraphQL::Types::JSON], null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    def likes
      Contexts::Helpers::Records.load_array(
        adapter: User,
        array: object.likes.uniq
      )
    end

    def likes_counter
      object.likes.size
    end

    def versions
      Contexts::Helpers::Versioning.versions(object.log_data)
    rescue Contexts::Helpers::Errors::VersionsNotFoundError
      []
    end
  end
end

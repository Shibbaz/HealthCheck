module Types
  class PostType < Types::BaseObject
    field :id, ID, null: false
    field :insights, String, null: false
    field :question, String, null: false
    field :feeling, Int, null: false
    field :likes, [Types::UserType], null: false
    field :likes_counter, Int, null: false
    field :versions, [GraphQL::Types::JSON], null: false
    field :comments, [Types::CommentType], null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    def likes
      Contexts::Helpers::Records.for(User).load_many(object.likes)
    end

    def comments
      object.comments
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

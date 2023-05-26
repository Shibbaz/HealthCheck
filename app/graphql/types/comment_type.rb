module Types
  class CommentType < Types::BaseObject
    field :id, ID, null: false
    field :text, String, null: false
    field :likes, [Types::UserType], null: false
    field :likes_counter, Int, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    def likes
      BatchLoader::GraphQL.for(object.likes.uniq).batch(default_value: []) do |user_ids, loader|
        User.where(id: user_ids).each { |user|
          loader.call(object.likes.uniq) { |data|
            data << user
          }
        }
      end
    end

    def likes_counter
      object.likes.size
    end
  end
end

module Types
  class PostType < Types::BaseObject
    field :id, ID, null: false
    field :insights, String, null: false
    field :question, String, null: false
    field :feeling, Int, null: false
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
      likes.as_json["batch_loader"].size
    end
  end
end

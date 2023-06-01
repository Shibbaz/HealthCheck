module Types
    class RecordType < Types::BaseObject
        field :likes, [Types::UserType], null: false
        field :likes_counter, Int, null: false
        field :versions, [GraphQL::Types::JSON], null: false
        field :created_at, GraphQL::Types::ISO8601DateTime, null: false
        field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
        
        def likes
            Services::Records.for(User).load_many(object.likes)
        end
      
        def likes_counter
            object.likes.size
        end
      
        def versions
            Services::Versions.versions(object.log_data)
        rescue Contexts::Helpers::Errors::VersionsNotFoundError
            []
        end
    end
end
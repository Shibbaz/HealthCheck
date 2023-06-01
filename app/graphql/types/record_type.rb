module Types
    class RecordType < Types::BaseObject
        field :likes, [Types::UserType], null: false
        field :likes_counter, Int, null: false
        field :versions, [GraphQL::Types::JSON], null: false
        
        def likes
            Contexts::Helpers::Records.for(User).load_many(object.likes)
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
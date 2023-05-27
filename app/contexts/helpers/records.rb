module Contexts
    module Helpers
        class Records
            def self.load(adapter:, id:)
                data = BatchLoader.for(id).batch do |ids, loader|
                    adapter.where(id: ids).each { |object| loader.call(object.id, object) }
                end
                return data
            end

            def self.load_array(adapter:, array:)
                BatchLoader::GraphQL.for(array).batch(default_value: []) do |ids, loader|
                    adapter.where(id: ids).each { |container|
                      loader.call(array) { |data|
                        data << container
                      }
                    }
                end
            end
        end
    end
end
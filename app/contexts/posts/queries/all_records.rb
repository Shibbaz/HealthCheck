module Contexts
  module Posts
    module Queries
      class AllRecords
        attr_reader :adapter

        def initialize(adapter: Post)
          @adapter = adapter
        end

        def call(user_id, args:)
          params = args.merge!({
            user_id: user_id
          })
          @adapter.apply_filtering(params)
        end
      end
    end
  end
end

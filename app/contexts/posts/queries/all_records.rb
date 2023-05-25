module Contexts
  module Posts
    module Queries
      class AllRecords
        attr_reader :adapter

        def initialize(adapter: Post)
          @adapter = adapter
        end

        def call(args:)
          @adapter.apply_filtering(args)
        end
      end
    end
  end
end

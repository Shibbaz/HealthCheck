module Concepts
  module Posts
    module Queries
      class AllRecords
        attr_reader :adapter

        def initialize(adapter: Post)
          @adapter = adapter
        end

        def call(args:)
          Concepts::Posts::Repository.new.apply_filtering(args:)
        end
      end
    end
  end
end

module Contexts
  module Posts
    module Queries
      class AllRecords
        attr_reader :adapter

        def initialize(adapter: Post)
          @adapter = adapter
        end

        def call(args:)
          Contexts::Posts::Repository.new.apply_filtering(args: args)
        end
      end
    end
  end
end

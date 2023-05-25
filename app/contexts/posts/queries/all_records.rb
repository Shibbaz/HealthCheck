module Contexts
  module Posts
    module Queries
      class AllRecords
        def call(args:)
          posts = Post.all
          raise Contexts::Posts::Errors::PostNotFoundError if posts == []
          Contexts::Posts::Repository.new.apply_filtering(posts: posts, args: args)
        end
      end
    end
  end
end

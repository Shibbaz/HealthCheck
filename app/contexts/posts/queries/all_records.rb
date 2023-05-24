module Contexts
  module Posts
    module Queries
      class AllRecords
        def call(args:)
          posts = Post.all
          raise Contexts::Posts::Errors::PostsNotFoundError if posts == []
          Contexts::Posts::Repository.new.apply_filtering(post: posts, args: args)
        end
      end
    end
  end
end

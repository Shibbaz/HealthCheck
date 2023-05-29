require "./app/contexts/records/repository"

module Contexts
  module Posts
    class Repository < Contexts::Records::Repository
      attr_reader :adapter

      def initialize(adapter: Post)
        @adapter = adapter
      end

      def apply_filtering(args:)
        posts = @adapter.all
        raise Contexts::Posts::Errors::PostNotFoundError if posts == []

        feeling ||= args[:filters][:feeling]
        likes ||= args[:filters][:likes]
        created_at ||= args[:filters][:created_at]
        followers ||= args[:filters][:followers]
        if !feeling.nil?
          return @adapter.filter_by_feeling(feeling)
        end

        if !likes.nil?
          return @adapter.filter_by_likes
        end

        if !created_at.nil?
          return @adapter.filter_by_created_at
        end

        if !followers.nil?
          current_user = User.find_by(id: args[:user_id])
          raise Contexts::Users::Errors::UserNotFoundError if current_user.nil?

          ids = current_user.followers
          return @adapter.show_users_content(ids)
        end

        posts
      end
    end
  end
end

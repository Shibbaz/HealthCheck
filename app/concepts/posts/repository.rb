# frozen_string_literal: true

require './app/concepts/records/repository'

module Concepts
  module Posts
    class Repository < Concepts::Records::Repository
      attr_reader :adapter

      def initialize(adapter: Post)
        @adapter = adapter
      end

      def apply_filtering(args:)
        posts = @adapter.all.load_async
        raise Concepts::Posts::Errors::PostNotFoundError if posts == []

        feeling ||= args[:filters][:feeling]
        likes ||= args[:filters][:likes]
        created_at ||= args[:filters][:created_at]
        followers ||= args[:filters][:followers]
        return @adapter.filter_by_feeling(feeling).load_async unless feeling.nil?

        return @adapter.filter_by_likes unless likes.nil?

        return @adapter.filter_by_created_at.load_async unless created_at.nil?

        unless followers.nil?
          current_user = User.find_by(id: args[:user_id])
          raise Concepts::Users::Errors::UserNotFoundError if current_user.nil?

          ids = current_user.followers
          return @adapter.show_users_content(ids)
        end

        posts
      end

      def upload(id:, file:)
        event_type = PostFileWasUploaded
        data = {
          id:,
          file:,
          adapter: @adapter
        }
        Services::Events::Publish.call(data:, event_type:)
      end
    end
  end
end

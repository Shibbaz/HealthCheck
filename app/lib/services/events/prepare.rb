module Services
  module Events
    class Prepare
      def self.call
        config = Rails.configuration
        config.event_store = RailsEventStore::Client.new(
          repository: RailsEventStoreActiveRecord::EventRepository.new(serializer: RubyEventStore::NULL),
          dispatcher: RubyEventStore::ComposedDispatcher.new(
              RailsEventStore::AfterCommitAsyncDispatcher.new(scheduler: CustomScheduler.new),
              RubyEventStore::Dispatcher.new,
            ),
            mapper: RubyEventStore::Mappers::Default.new
        )
        {
          Concepts::Users::Commands::CreateSingleUser => UserWasCreated,
          Concepts::Posts::Commands::CreateSinglePost => PostWasCreated,
          Concepts::Posts::Commands::AddLikeToPost => PostWasLiked,
          Concepts::Posts::Commands::UnlikePost => PostWasUnliked,
          Concepts::Posts::Commands::UpdatePost => PostWasUpdated,
          Concepts::Posts::Commands::DeletePost => PostWasDeleted,
          Concepts::Comments::Commands::CreateSingleComment => CommentWasCreated,
          Concepts::Comments::Commands::AddLikeToComment => CommentWasLiked,
          Concepts::Comments::Commands::UnlikeComment => CommentWasUnliked,
          Concepts::Comments::Commands::UpdateComment => CommentWasUpdated,
          Concepts::Comments::Commands::DeleteComment => CommentWasDeleted,
          Concepts::Users::Commands::AddUserAvatar => UserAvatarWasUploaded,
          Concepts::Notifications::Commands::NotificationOnComment => UserWasNotifiedOnComment,
          Concepts::Notifications::Commands::NotificationOnLike => UserWasNotifiedOnLike,
          Concepts::Posts::Commands::AddPostFile => PostFileWasUploaded,
          Concepts::Users::Commands::UpdateUser => UserWasUpdated,
          Concepts::Users::Commands::AddFollowerToUser => UserWasFollowed
        }
      end
    end
  end
end

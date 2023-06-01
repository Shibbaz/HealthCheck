# frozen_string_literal: true

Rails.configuration.to_prepare do
  config = Rails.configuration
  config.event_store = RailsEventStore::Client.new

  event_subscriptions = {
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
      Concepts::Notifications::Commands::NotificationOnLike => UserWasNotifiedOnLike
    }
    Services::Events::Subscribe.call(event_store: config.event_store, events: event_subscriptions)
  end

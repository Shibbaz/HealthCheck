# frozen_string_literal: true

Rails.configuration.to_prepare do
  config = Rails.configuration
  config.event_store = RailsEventStore::Client.new

  event_subscriptions = {
      Contexts::Users::Commands::CreateSingleUser => UserWasCreated,
      Contexts::Posts::Commands::CreateSinglePost => PostWasCreated,
      Contexts::Posts::Commands::AddLikeToPost => PostWasLiked,
      Contexts::Posts::Commands::UnlikePost => PostWasUnliked,
      Contexts::Posts::Commands::UpdatePost => PostWasUpdated,
      Contexts::Posts::Commands::DeletePost => PostWasDeleted,
      Contexts::Comments::Commands::CreateSingleComment => CommentWasCreated,
      Contexts::Comments::Commands::AddLikeToComment => CommentWasLiked,
      Contexts::Comments::Commands::UnlikeComment => CommentWasUnliked,
      Contexts::Comments::Commands::UpdateComment => CommentWasUpdated,
      Contexts::Comments::Commands::DeleteComment => CommentWasDeleted,
      Contexts::Users::Commands::AddUserAvatar => UserAvatarWasUploaded,
      Contexts::Notifications::Commands::NotificationOnComment => UserWasNotifiedOnComment,
      Contexts::Notifications::Commands::NotificationOnLike => UserWasNotifiedOnLike
    }
    Services::Events::Subscribe.call(event_store: config.event_store, events: event_subscriptions)
  end

# frozen_string_literal: true

Rails.configuration.to_prepare do
  config = Rails.configuration
  config.event_store = RailsEventStore::Client.new
  config.event_store.subscribe(Contexts::Users::Commands::CreateSingleUser.new, to: [UserWasCreated])
  config.event_store.subscribe(Contexts::Posts::Commands::CreateSinglePost.new, to: [PostWasCreated])
  config.event_store.subscribe(Contexts::Posts::Commands::AddLikeToPost.new, to: [PostWasLiked])
  config.event_store.subscribe(Contexts::Posts::Commands::UnlikePost.new, to: [PostWasUnliked])
  config.event_store.subscribe(Contexts::Posts::Commands::UpdatePost.new, to: [PostWasUpdated])
  config.event_store.subscribe(Contexts::Posts::Commands::DeletePost.new, to: [PostWasDeleted])
  config.event_store.subscribe(Contexts::Comments::Commands::CreateSingleComment.new, to: [CommentWasCreated])
  config.event_store.subscribe(Contexts::Comments::Commands::AddLikeToComment.new, to: [CommentWasLiked])
  config.event_store.subscribe(Contexts::Comments::Commands::UnlikeComment.new, to: [CommentWasUnliked])
  config.event_store.subscribe(Contexts::Comments::Commands::UpdateComment.new, to: [CommentWasUpdated])
  config.event_store.subscribe(Contexts::Comments::Commands::DeleteComment.new, to: [CommentWasDeleted])
  config.event_store.subscribe(Contexts::Users::Commands::AddUserAvatar.new, to: [UserAvatarWasUploaded])
end

Rails.configuration.to_prepare do
  $event_store = RailsEventStore::Client.new
  $event_store.subscribe(Contexts::Users::Commands::CreateSingleUser.new, to: [UserWasCreated])
  $event_store.subscribe(Contexts::Posts::Commands::CreateSinglePost.new, to: [PostWasCreated])
  $event_store.subscribe(Contexts::Posts::Commands::AddLikeToPost.new, to: [PostWasLiked])
  $event_store.subscribe(Contexts::Posts::Commands::UnlikePost.new, to: [PostWasUnliked])
  $event_store.subscribe(Contexts::Posts::Commands::UpdatePost.new, to: [PostWasUpdated])
  $event_store.subscribe(Contexts::Posts::Commands::DeletePost.new, to: [PostWasDeleted])
  $event_store.subscribe(Contexts::Comments::Commands::CreateSingleComment.new, to: [CommentWasCreated])
  $event_store.subscribe(Contexts::Comments::Commands::AddLikeToComment.new, to: [CommentWasLiked])
  $event_store.subscribe(Contexts::Comments::Commands::UnlikeComment.new, to: [CommentWasUnliked])
  $event_store.subscribe(Contexts::Comments::Commands::UpdateComment.new, to: [CommentWasUpdated])
  $event_store.subscribe(Contexts::Comments::Commands::DeleteComment.new, to: [CommentWasDeleted])
  $event_store.subscribe(Contexts::Users::Commands::AddUserAvatar.new, to: [UserAvatarWasUploaded])

end

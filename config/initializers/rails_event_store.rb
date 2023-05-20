Rails.configuration.to_prepare do
  $event_store = RailsEventStore::Client.new
  $event_store.subscribe(Contexts::Users::Commands::CreateSingleUser.new, to: [UserWasCreated])
  $event_store.subscribe(Contexts::Posts::Commands::CreateSinglePost.new, to: [PostWasCreated])
  $event_store.subscribe(Contexts::Posts::Commands::AddLikeToPost.new, to: [PostWasLiked])
  $event_store.subscribe(Contexts::Posts::Commands::UnlikePost.new, to: [PostWasUnliked])
end

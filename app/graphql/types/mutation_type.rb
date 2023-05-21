module Types
  class MutationType < Types::BaseObject
    field :create_user, mutation: Mutations::CreateUserMutation
    field :signin_user, mutation: Mutations::SignInUserMutation
    field :add_like_to_post, mutation: Mutations::AddLikeToPostMutation
    field :unlike_to_post, mutation: Mutations::UnlikePostMutation
    field :create_post, mutation: Mutations::CreatePostMutation
    field :update_post_insights, mutation: Mutations::UpdatePostInsightsMutation
  end
end

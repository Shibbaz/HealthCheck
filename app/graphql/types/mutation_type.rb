# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_user, mutation: Mutations::CreateUserMutation
    field :signin_user, mutation: Mutations::SignInUserMutation
    field :add_like_to_post, mutation: Mutations::AddLikeToPostMutation
    field :unlike_to_post, mutation: Mutations::UnlikePostMutation
    field :create_post, mutation: Mutations::CreatePostMutation
    field :update_post_insights, mutation: Mutations::UpdatePostInsightsMutation
    field :delete_post, mutation: Mutations::DeletePostMutation
    field :add_like_to_comment, mutation: Mutations::AddLikeToCommentMutation
    field :unlike_to_comment, mutation: Mutations::UnlikeCommentMutation
    field :create_comment, mutation: Mutations::CreateCommentMutation
    field :update_comment_text, mutation: Mutations::UpdateCommentTextMutation
    field :delete_comment_text, mutation: Mutations::DeleteCommentMutation
    field :upload_profile_image, mutation: Mutations::UpdateUserProfileImageMutation
    field :upload_post_file, mutation: Mutations::UpdatePostFileMutation
    field :update_user, mutation: Mutations::UpdateUserMutation
    field :add_follow_to_user, mutation: Mutations::AddFollowerToUserMutation
    field :add_stripe_key_to_user, mutation: Mutations::AddStripeKeyToUserMutation
    field :make_transaction_to_user_stripe_account, mutation: Mutations::MakeTransactionToUserStripeAccount
  end
end

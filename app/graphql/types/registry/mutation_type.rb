# frozen_string_literal: true

module Types
  module Registry
    class MutationType < Types::Base::Object
      field :create_user, mutation: Mutations::Users::CreateMutation
      field :signin_user, mutation: Mutations::Users::SignInMutation
      field :add_like_to_post, mutation: Mutations::Posts::AddLikeMutation
      field :unlike_to_post, mutation: Mutations::Posts::UnlikeMutation
      field :create_post, mutation: Mutations::Posts::CreateMutation
      field :update_post_insights, mutation: Mutations::Posts::UpdateTextMutation
      field :delete_post, mutation: Mutations::Posts::DeleteMutation
      field :add_like_to_comment, mutation: Mutations::Comments::AddLikeMutation
      field :unlike_to_comment, mutation: Mutations::Comments::UnlikeMutation
      field :create_comment, mutation: Mutations::Comments::CreateMutation
      field :update_comment_text, mutation: Mutations::Comments::UpdateTextMutation
      field :delete_comment_text, mutation: Mutations::Comments::DeleteMutation
      field :upload_profile_image, mutation: Mutations::Users::UpdateProfileImageMutation
      field :upload_post_file, mutation: Mutations::Posts::UpdateFileMutation
      field :update_user, mutation: Mutations::Users::UpdateMutation
      field :add_follow_to_user, mutation: Mutations::Users::AddFollowerMutation
    end
  end
end

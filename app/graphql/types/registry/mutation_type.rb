module Types
  module Registry
    class MutationType < Types::Base::Object
      field :create_user, mutation: Mutations::Users::CreateMutation, null: false do
        extension GraphAttack::RateLimit, threshold: 15, interval: 60
      end
      field :signin_user, mutation: Mutations::Users::SignInMutation, null: false do
        extension GraphAttack::RateLimit, threshold: 15, interval: 60
      end
      field :add_like_to_post, mutation: Mutations::Posts::AddLikeMutation, null: false do
        extension GraphAttack::RateLimit, threshold: 15, interval: 60
      end
      field :unlike_to_post, mutation: Mutations::Posts::UnlikeMutation, null: false do
        extension GraphAttack::RateLimit, threshold: 15, interval: 60
      end
      field :create_post, mutation: Mutations::Posts::CreateMutation, null: false do
        extension GraphAttack::RateLimit, threshold: 15, interval: 60
      end
      field :update_post_insights, mutation: Mutations::Posts::UpdateTextMutation, null: false do
        extension GraphAttack::RateLimit, threshold: 15, interval: 60
      end
      field :delete_post, mutation: Mutations::Posts::DeleteMutation, null: false do
        extension GraphAttack::RateLimit, threshold: 15, interval: 60
      end
      field :add_like_to_comment, mutation: Mutations::Comments::AddLikeMutation, null: false do
        extension GraphAttack::RateLimit, threshold: 15, interval: 60
      end
      field :unlike_to_comment, mutation: Mutations::Comments::UnlikeMutation, null: false do
        extension GraphAttack::RateLimit, threshold: 15, interval: 60
      end
      field :create_comment, mutation: Mutations::Comments::CreateMutation, null: false do
        extension GraphAttack::RateLimit, threshold: 15, interval: 60
      end
      field :update_comment_text, mutation: Mutations::Comments::UpdateTextMutation, null: false do
        extension GraphAttack::RateLimit, threshold: 15, interval: 60
      end
      field :delete_comment_text, mutation: Mutations::Comments::DeleteMutation, null: false do
        extension GraphAttack::RateLimit, threshold: 15, interval: 60
      end
      field :upload_profile_image, mutation: Mutations::Users::UpdateProfileImageMutation, null: false do
        extension GraphAttack::RateLimit, threshold: 15, interval: 60
      end
      field :upload_post_file, mutation: Mutations::Posts::UpdateFileMutation, null: false do
        extension GraphAttack::RateLimit, threshold: 15, interval: 60
      end
      field :update_user, mutation: Mutations::Users::UpdateMutation, null: false do
        extension GraphAttack::RateLimit, threshold: 15, interval: 60
      end
      field :add_follow_to_user, mutation: Mutations::Users::AddFollowerMutation, null: false do
        extension GraphAttack::RateLimit, threshold: 15, interval: 60
      end
    end
  end
end

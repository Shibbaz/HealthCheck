module Mutations
    class CreatePostMutation < BaseMutation
      argument :user_id, ID, required: true
      argument :feeling, Int, required: true
      argument :question, String, required: true
      argument :likes, ID, required: true
      argument :insights, String, required: true
  
      def resolve(**args)
        Helpers::Authenticate.new.call(context: context)
        args = args.merge({ user_id: context[:current_user].id })
        Contexts::Posts::Repository.new.create_post(args: args)
  
        { status: 200 }
      end
    end
  end
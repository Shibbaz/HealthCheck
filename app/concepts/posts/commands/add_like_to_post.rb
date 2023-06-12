# Liking a post by current user on Post by post id
# Inherit from Concepts::Records::Commands::LikeRecord
require './app/concepts/records/commands/add_like_to_record'

module Concepts
  module Posts
    module Commands
      class AddLikeToPost < ::Concepts::Records::Commands::AddLikeToRecord
      end
    end
  end
end

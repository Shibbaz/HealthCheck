# Liking a comment by current user on Comment by comment id
# Inherit from the AddLikeToRecord command
require './app/concepts/records/commands/add_like_to_record'

module Concepts
  module Comments
    module Commands
      class AddLikeToComment < ::Concepts::Records::Commands::AddLikeToRecord
      end
    end
  end
end

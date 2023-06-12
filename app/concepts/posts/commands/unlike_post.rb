# Unliking a post by current user on Post by post id
require './app/concepts/records/commands/unlike_record'

module Concepts
  module Posts
    module Commands
      class UnlikePost < ::Concepts::Records::Commands::UnlikeRecord
      end
    end
  end
end

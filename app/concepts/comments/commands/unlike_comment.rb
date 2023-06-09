# Unliking a comment by current user on comment by comment id
# Inherit from Concepts::Records::Commands::UnlikeRecord
require './app/concepts/records/commands/unlike_record'

module Concepts
  module Comments
    module Commands
      class UnlikeComment < ::Concepts::Records::Commands::UnlikeRecord
      end
    end
  end
end

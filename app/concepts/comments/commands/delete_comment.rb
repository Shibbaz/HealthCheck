# Deleting current user's comment by comment id
# Inherit from Concepts::Records::Commands::DeleteRecord
require './app/concepts/records/commands/delete_record'

module Concepts
  module Comments
    module Commands
      class DeleteComment < ::Concepts::Records::Commands::DeleteRecord
      end
    end
  end
end

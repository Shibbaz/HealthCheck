# Deleting current user's post by post id
# Inherit from Concepts::Records::Commands::DeleteRecord
require './app/concepts/records/commands/delete_record'

module Concepts
  module Posts
    module Commands
      class DeletePost < ::Concepts::Records::Commands::DeleteRecord
      end
    end
  end
end

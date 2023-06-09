# Updating post found by id
# Inherit from Concepts::Records::Commands::UpdateRecord
require './app/concepts/records/commands/update_record'
module Concepts
  module Posts
    module Commands
      class UpdatePost < ::Concepts::Records::Commands::UpdateRecord
      end
    end
  end
end

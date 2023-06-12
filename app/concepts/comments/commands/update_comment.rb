# Updating comment found by id
# Inherit from Concepts::Records::Commands::UpdateRecord
require './app/concepts/records/commands/update_record'

module Concepts
  module Comments
    module Commands
      class UpdateComment < ::Concepts::Records::Commands::UpdateRecord
      end
    end
  end
end

# Creating single comment by current user
# Inherit from Concepts::Records::Commands::CreateRecord
require './app/concepts/records/commands/create_record'

module Concepts
  module Comments
    module Commands
      class CreateSingleComment < ::Concepts::Records::Commands::CreateRecord
      end
    end
  end
end

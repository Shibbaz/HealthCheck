# Creating single post by current user
# Inherit from Concepts::Records::Commands::CreateRecord
require './app/concepts/records/commands/create_record'

module Concepts
  module Posts
    module Commands
      class CreateSinglePost < ::Concepts::Records::Commands::CreateRecord
      end
    end
  end
end

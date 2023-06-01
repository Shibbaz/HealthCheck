# frozen_string_literal: true

require './app/concepts/records/commands/create_record'
module Concepts
  module Posts
    module Commands
      class CreateSinglePost < ::Concepts::Records::Commands::CreateRecord
      end
    end
  end
end

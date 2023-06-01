# frozen_string_literal: true

require './app/concepts/records/commands/delete_record'
module Concepts
  module Posts
    module Commands
      class DeletePost < ::Concepts::Records::Commands::DeleteRecord
      end
    end
  end
end

# frozen_string_literal: true

require './app/concepts/records/commands/delete_record'
module Concepts
  module Comments
    module Commands
      class DeleteComment < ::Concepts::Records::Commands::DeleteRecord
      end
    end
  end
end

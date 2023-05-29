# frozen_string_literal: true

require './app/contexts/records/commands/delete_record'
module Contexts
  module Comments
    module Commands
      class DeleteComment < ::Contexts::Records::Commands::DeleteRecord
      end
    end
  end
end

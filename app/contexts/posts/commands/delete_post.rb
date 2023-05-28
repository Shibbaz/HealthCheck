require "./app/contexts/records/commands/delete_record"
module Contexts
  module Posts
    module Commands
      class DeletePost < ::Contexts::Records::Commands::DeleteRecord
      end
    end
  end
end

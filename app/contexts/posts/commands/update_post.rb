# frozen_string_literal: true

require './app/contexts/records/commands/update_record'
module Contexts
  module Posts
    module Commands
      class UpdatePost < ::Contexts::Records::Commands::UpdateRecord
      end
    end
  end
end

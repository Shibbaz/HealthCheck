# frozen_string_literal: true

require './app/contexts/records/commands/unlike_record'
module Contexts
  module Posts
    module Commands
      class UnlikePost < ::Contexts::Records::Commands::UnlikeRecord
      end
    end
  end
end

# frozen_string_literal: true

require './app/concepts/records/commands/unlike_record'

module Concepts
  module Comments
    module Commands
      class UnlikeComment < ::Concepts::Records::Commands::UnlikeRecord
      end
    end
  end
end

# frozen_string_literal: true

require './app/concepts/records/commands/add_like_to_record'

module Concepts
  module Comments
    module Commands
      class AddLikeToComment < ::Concepts::Records::Commands::AddLikeToRecord
      end
    end
  end
end

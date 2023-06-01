# frozen_string_literal: true

require './app/concepts/records/commands/add_like_to_record'

module Concepts
  module Posts
    module Commands
      class AddLikeToPost < ::Concepts::Records::Commands::AddLikeToRecord
      end
    end
  end
end

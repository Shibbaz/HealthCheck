# frozen_string_literal: true

require './app/contexts/records/commands/add_like_to_record'

module Contexts
  module Posts
    module Commands
      class AddLikeToPost < ::Contexts::Records::Commands::AddLikeToRecord
      end
    end
  end
end

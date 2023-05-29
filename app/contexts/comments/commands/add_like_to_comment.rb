# frozen_string_literal: true

require './app/contexts/records/commands/add_like_to_record'

module Contexts
  module Comments
    module Commands
      class AddLikeToComment < ::Contexts::Records::Commands::AddLikeToRecord
      end
    end
  end
end

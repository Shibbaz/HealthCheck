# frozen_string_literal: true

require './app/contexts/records/commands/create_record'

module Contexts
  module Comments
    module Commands
      class CreateSingleComment < ::Contexts::Records::Commands::CreateRecord
      end
    end
  end
end

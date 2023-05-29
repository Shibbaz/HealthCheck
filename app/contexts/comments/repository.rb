# frozen_string_literal: true

require './app/contexts/records/repository'
module Contexts
  module Comments
    class Repository < Contexts::Records::Repository
      attr_reader :adapter

      def initialize(adapter: Comment)
        @adapter = adapter
      end
    end
  end
end

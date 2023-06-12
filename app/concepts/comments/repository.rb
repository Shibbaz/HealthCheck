require './app/concepts/records/repository'
module Concepts
  module Comments
    class Repository < Concepts::Records::Repository
      attr_reader :adapter

      def initialize(adapter: Comment)
        @adapter = adapter
      end
    end
  end
end

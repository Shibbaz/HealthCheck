# frozen_string_literal: true

module Services
  module Errors
    class VersionsNotFoundError < ActiveRecord::RecordNotFound
      def message
        'Versions are not found'
      end
    end
  end
end

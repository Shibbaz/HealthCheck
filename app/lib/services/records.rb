# frozen_string_literal: true

module Services
  class Records < GraphQL::Batch::Loader
    def self.build_error(adapter:)
      error_name = "Concepts::#{adapter}s::Errors::#{adapter}NotFoundError"
      error_type = error_name.constantize
    end

    def self.build_event(adapter:, event_type:)
      event_name = "#{adapter}Was#{event_type}"
      event_name.constantize
    end

    def self.load(adapter:, id:)
      adapter.find(id)
    end

    def initialize(model)
      @model = model
    end

    def perform(ids)
      @model.where(id: ids).load_async.each { |record| fulfill(record.id, record) }
      ids.each { |id| fulfill(id, nil) unless fulfilled?(id) }
    end
  end
end

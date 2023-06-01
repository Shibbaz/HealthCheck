# frozen_string_literal: true

module Services
  class Versions
    def self.versions(log)
      raise Services::Errors::VersionsNotFoundError if log.nil?

      log.data['h'][1...].pluck('c').reverse.select do |data|
        data.key?('insights') == true || data.key?('question') == true || data.key?('text') == true
      end.each_with_index.map do |item, index|
        {
          id: index
        }.merge(item)
      end
    end
  end
end


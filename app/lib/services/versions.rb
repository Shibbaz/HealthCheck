# Purpose: Service::Versions is used to get the history of posts and comments

module Services
  class Versions
    def self.versions(log)
      raise Services::Errors::VersionsNotFoundError if log.nil?

      log.data['h'][1...].pluck('c').reverse.select do |data|
        self.validate(data)
      end.each_with_index.map do |item, index|
        { id: index }.merge(item)
      end
    end
    
    def self.validate(data)
      data.key?('question') == true || data.key?('text') == true
    end
  end
end

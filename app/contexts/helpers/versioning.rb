module Contexts
  module Helpers
    class Versioning
      def self.versions(log)
        byebug
        log.data["h"][1...].pluck("c").reverse.select { |data|
          data.key?("insights") == true || data.key?("question") == true
        }.each_with_index.map { |item, index|
          {
            id: index
          }.merge(item)
        }
      end
    end
  end
end

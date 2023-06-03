module Services
  class GraphQlLogger
    def self.call(theme: Rouge::Themes::Base16)
      GraphQL::RailsLogger.configure do |config|
        config.theme = theme
      end
    end
  end
end

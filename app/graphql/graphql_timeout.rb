class GraphqlTimeout < GraphQL::Schema::Timeout
    def handle_timeout(error, query)
      Rails.logger.warn("GraphQL Timeout: #{error.message}: #{query.query_string}")
    end
end
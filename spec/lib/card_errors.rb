module StripeMock
    module CardErrors
      def self.add_json_body(error_values)
        error_keys = [:message, :param, :code]
  
        json_hash = Hash[error_keys.zip error_values]
        json_hash[:type] = 'card_error'
        json_hash[:decline_code] = get_decline_code(json_hash[:code])
  
        error_code = error_values.delete_at(2)
        error_values.last.merge!(code: error_code, json_body: { error: json_hash }, http_body: { error: json_hash })
  
        error_values
    end
end
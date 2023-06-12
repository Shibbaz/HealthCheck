class Error
    def self.json(e)
        return {
          error: {
            message: e.class,
          },
          status: 404
        }
    end

    def self.raise(record)
      error_type = Services::Records.build_error(adapter: record.class)
      record.nil? ? (raise error_type) : nil
    end
end

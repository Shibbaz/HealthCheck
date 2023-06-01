# frozen_string_literal: true
module Services
  class IpFiltering
    IP_WHITELIST = ['::1', 'localhost', '127.0.0.1'].freeze
    def initialize(app)
      @app = app
    end

    def call(env)
      return @app.call(env) if IP_WHITELIST.include? env['REMOTE_ADDR']

      [403, {}, ['Your IP is not on IP While List!']]
    end
  end
end
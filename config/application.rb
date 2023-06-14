# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Health
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.session_store :cookie_store, key: '_interslice_session'
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use config.session_store, config.session_options
    config.api_only = true
    config.docker = true
    config.eager_load_paths += Dir[Rails.root.join('app/concepts/**/**/*.rb')].each { |rb| require rb }
    config.eager_load_paths += Dir[Rails.root.join('app/modules/**/**/*.rb')].each { |rb| require rb }
    config.eager_load_paths += Dir[Rails.root.join('app/lib/**/*.rb')].each { |rb| require rb }
    ApolloUploadServer::Middleware.strict_mode = true

    Bundler.require(*Rails.groups)

    Dotenv::Railtie.load if %w[development test].include? ENV['RAILS_ENV']
    config.active_job.queue_adapter = :sidekiq
    GraphQL::FragmentCache.configure do |config|
      config.default_options = {
        expires_in: 1.hour,
        schema_cache_key: nil
      }
    end
    config.active_record.cache_versioning = true
    config.graphql_fragment_cache.store = :redis_cache_store, { url: ENV['REDIS_URL'] }
    GraphQL::FragmentCache.enabled = false if Rails.env.test?
    config.middleware.insert_before ActionDispatch::Static, Rack::Deflater
  end
end

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

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.session_store :cookie_store, key: '_interslice_session'
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use config.session_store, config.session_options
    config.api_only = true
    config.docker = true
    config.eager_load_paths += Dir[Rails.root.join('app/concepts/**/**/*.rb')].each { |rb| require rb }
    config.eager_load_paths += Dir[Rails.root.join('app/modules/**/**/*.rb')].each { |rb| require rb }
    config.eager_load_paths += Dir[Rails.root.join('app/lib/**/*.rb')].each { |rb| require rb }

    # config.middleware.use IpFiltering
    ApolloUploadServer::Middleware.strict_mode = true

    Bundler.require(*Rails.groups)

    Dotenv::Railtie.load if %w[development test].include? ENV['RAILS_ENV']
    config.active_job.queue_adapter = :sidekiq
    GraphQL::FragmentCache.configure do |config|
      config.default_options = {
        expires_in: 1.hour, # Expire cache keys after 1 hour
        schema_cache_key: nil # Do not clear the cache on each schema change
      }
    end
    config.graphql_fragment_cache.store = :redis_cache_store, { url: ENV['REDIS_URL'] }
    GraphQL::FragmentCache.enabled = false if Rails.env.test?
    config.middleware.insert_before ActionDispatch::Static, Rack::Deflater
  end
end

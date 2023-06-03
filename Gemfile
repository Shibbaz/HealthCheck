# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.0.4', '>= 7.0.4.3'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 5.0'

gem 'rack-cors'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem 'bcrypt', '~> 3.1.7'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

gem 'graphql'

gem 'standard'

gem 'simplecov', require: false, group: :test

gem 'graphql-batch'

gem 'search_object_graphql'

gem 'pg_search'

gem 'rails_event_store'

gem 'faker'

gem 'obscenity'

gem 'logidze', '~> 1.1'

gem 'fx'

gem 'rspec-sqlimit'

gem 'aws-sdk'

gem 'dotenv-rails', groups: %i[development test]

gem 'apollo_upload_server', '2.1'

gem 'acidic_job'

gem 'awesome_print'
gem 'graphql-rails_logger'
gem 'pg_trgm'
gem 'rails-pg-extras'
gem 'redis'
gem 'rubocop-performance', require: false
gem 'sidekiq'

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem "rack-cors"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'rspec-graphql_matchers'
  gem 'rspec-rails', '~> 6.0.0'
end

group :test do
  gem 'database_cleaner'
  gem 'database_cleaner-active_record'
  gem 'database_cleaner-redis'
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
  gem 'bundler-audit'
end

group :test do
  gem 'ruby_event_store-rspec'
end

group :development, :test do
  gem 'appmap'
  gem 'hirb'
  gem 'hirb-unicode-steakknife', require: 'hirb-unicode'
  gem 'pry-byebug'
  gem 'pry-stack_explorer'
end

gem 'factory_bot_rails'

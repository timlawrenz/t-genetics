# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.4.1'

gem 'aasm'
# gem 'bcrypt', '~> 3.1.7' # TODO: Review: Is this needed by the engine's core logic?
gem 'bootsnap', require: false
gem 'gl_command', git: 'https://github.com/givelively/gl_command.git'
# gem 'haml-rails' # TODO: Review: Is this needed (e.g. for a dummy app in tests)?
gem 'oj'
gem 'pg', '~> 1.1'
gem 'puma'
gem 'rails'
gem 'sentry-rails'
gem 'sentry-ruby'

group :development, :test do
  gem 'brakeman'
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'reek'
  gem 'timecop'
  # gem 'webdrivers' # TODO: Review if needed for engine-specific tests after removing Capybara
  gem 'packwerk'
end

group :development do
  gem 'gl_lint', require: false
  gem 'listen'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-commands-rubocop'
end

group :test do
  gem 'database_cleaner'
  gem 'database_cleaner-active_record'
  gem 'n_plus_one_control'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
end

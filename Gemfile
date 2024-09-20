# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.4'

gem 'aasm'
gem 'bcrypt', '~> 3.1.7'
gem 'bootsnap', require: false
gem 'haml-rails'
gem 'importmap-rails'
gem 'oj'
gem 'pg', '~> 1.1'
gem 'puma'
gem 'rails'
gem 'sassc-rails'
gem 'sentry-rails'
gem 'sentry-ruby'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'tailwindcss-rails'
gem 'gl_command', git: 'https://github.com/givelively/gl_command.git'
gem 'turbo-rails'

group :development, :test do
  gem 'brakeman'
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'dotenv-rails'
  gem 'factory_bot_rails'
  gem 'reek'
  gem 'timecop'
  gem 'webdrivers'
end

group :development do
  gem 'listen'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-commands-rubocop'
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'database_cleaner'
  gem 'database_cleaner-active_record'
  gem 'launchy'
  gem 'n_plus_one_control'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
end

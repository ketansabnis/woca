source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.2', '>= 5.2.2.1'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Custom Added
group :development do
  gem 'capistrano'
  gem 'capistrano-rails'
  gem 'capistrano-passenger'
  gem 'capistrano-sidekiq', github: 'seuros/capistrano-sidekiq'
  gem 'capistrano-rvm'
end

group :development, :test do
  gem "premailer"
  gem "letter_opener"
end

group :production, :staging do
  gem 'honeybadger'
end
gem 'mongoid', '~> 6.1.0'
gem 'mongoid-autoinc'
gem 'devise'
gem 'active_model_otp'
gem 'simple_token_authentication', '~> 1.0'
gem 'pundit'
gem 'sidekiq'
gem 'redis-namespace'
gem 'will_paginate_mongoid'
gem 'mongoid-observers', '~> 0.3.0'
gem 'rails-observers',  github: 'rails/rails-observers'
gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'
gem 'fog-aws'
gem 'money-rails'
gem 'aasm'
gem 'graphviz_aasm'
gem 'whenever', :require => false
gem 'asset_sync'
gem 'phonelib'
gem 'bootstrap'
gem 'jquery-rails'
gem 'bootstrap-email'
gem 'mailgun-ruby'
gem 'humanize', require: 'humanize'
gem 'mongoid-autoinc'

group :test, :development do
  gem 'faker', github: 'stympy/faker'
  gem 'shoulda', '~> 3.5'
  gem 'shoulda-matchers', '3.1.2'
  gem "factory_bot_rails"
end

group :test do
  gem 'rails-controller-testing'
  gem 'rspec-sidekiq'
  gem 'database_cleaner'
  gem 'simplecov', require: false
end
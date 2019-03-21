require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
# require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
require "rails/test_unit/railtie"

if Rails.env == "production" || Rails.env == "staging"
  ENV_CONFIG = (YAML.load(File.open( "/usr/local/woca-env.yml" ).read).symbolize_keys).with_indifferent_access
else
  ENV_CONFIG = (YAML.load(File.open( "config/woca-env.yml" ).read).symbolize_keys).with_indifferent_access
end


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Woca
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.autoload_paths += ["#{config.root}/app/observers/**/*", "#{config.root}/app/policies/**/*", "#{config.root}/app/services/**/*", "#{config.root}/app/workers/**/*", "#{config.root}/app/uploaders/**/*"]
    config.mongoid.observers = Dir["#{Rails.root}/app/observers/**/*.rb"].collect{ |f| f.gsub!("#{Rails.root}/app/observers/", "").gsub!(".rb", "")}
    config.action_mailer.preview_path = "#{Rails.root}/spec/mailers/previews"
    config.active_job.queue_adapter = :sidekiq
    config.to_prepare do
      Devise::Mailer.layout "mailer"
    end

    config.generators do |g|
      g.orm :mongoid
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
require 'woca'

# config/application.rb
require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module ImageGalleryApp 
  class Application < Rails::Application
    config.load_defaults 8.0
    config.autoload_lib(ignore: %w[assets tasks])
    
    # Fix for Rails 8 + Devise compatibility issue
    config.action_controller.raise_on_missing_callback_actions = false
    
    # Active Storage configuration
    config.active_storage.variant_processor = :mini_magick
  end
end
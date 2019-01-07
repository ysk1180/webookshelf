require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Webookshelf
  class Application < Rails::Application
    config.load_defaults 5.2

    config.time_zone = 'Tokyo'
    config.i18n.default_locale = :ja

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        # origins 'images-fe.ssl-images-amazon.com'
        resource '*', headers: :any, methods: [:get, :post, :options]
      end
    end
  end
end

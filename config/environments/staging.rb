require Rails.root.join("config/environments/production")

DevelopmentBootcamp::Application.configure do
  # Override settings defined in the production environment here
  config.force_ssl = false

  # Use a different cache store namespace on staging
  config.cache_store = :dalli_store, (ENV['MEMCACHE_SERVERS'] || 'localhost:11211'), {
    namespace: 'dbcstaging',
    compress: true,
    pool_size: Integer(ENV['MAX_THREADS'] || 16)
  }

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.action_controller.asset_host = "http://assets.example.com"
  config.action_controller.default_url_options = {
    :host => "staging.developmentbootcamp.nl"
  }

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default_url_options = { host: 'staging.developmentbootcamp.nl' }
end

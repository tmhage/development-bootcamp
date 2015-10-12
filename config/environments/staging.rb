require Rails.root.join("config/environments/production")

DevelopmentBootcamp::Application.configure do
  # Override settings defined in the production environment here
  config.action_mailer.default_url_options = { host: 'staging.developmentbootcamp.nl' }
end

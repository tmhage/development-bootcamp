class DevelopmentBootcamp::Application < Rails::Application
  config.middleware.insert_before(Rack::Runtime, Rack::Rewrite) do
    r301 %r{/(.*)}, "https://www.developmentbootcamp.nl/$1", host: "developmentbootcamp.nl"
    r301 %r{/(.*)}, "https://www.developmentbootcamp.nl/$1", host: "developmentbootcamp.eu"
    r301 %r{/(.*)}, "https://www.developmentbootcamp.nl/$1", host: "developerbootcamp.nl"
  end
end


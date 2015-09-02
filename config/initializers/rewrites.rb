class DevelopmentBootcamp::Application < Rails::Application
  config.middleware.insert_before(Rack::Runtime, Rack::Rewrite) do
    r301 %r{/(.*)}, "https://www.developmentbootcamp.nl/$1", if: Proc.new { |rack_env|
      rack_env['SERVER_NAME'] != 'www.developmentbootcamp.nl'
    }
  end
end


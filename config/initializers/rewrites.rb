class DevelopmentBootcamp::Application < Rails::Application
  config.middleware.insert_before(Rack::Runtime, Rack::Rewrite) do
    r301 %r{/(.*)}, "https://www.developmentbootcamp.nl/$1", if: Proc.new { |rack_env|
      ::Rails.env.production? && !!!(rack_env['SERVER_NAME'].match(/^www\.developmentbootcamp\.(nl|com)$/))
    }

    # Rewrite old /program routes to /courses
    r301 '/program/level-1', '/courses/beginner-bootcamp'
    r301 '/program/level-2', '/courses/intermediate-bootcamp'
    r301 '/program/level-3', '/courses/advanced-bootcamp'
    r301 %r{/program/(.*)}, '/courses/$1'
    r301 '/program', '/courses'

    # Rewrite old /tickets path to /enroll
    r301 '/tickets', '/enroll'
  end
end

class Middleware::Domains
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)

    if request.host.match(/\.nl(\.dev)?$/)
      I18n.locale = :nl
    else
      I18n.locale = :en
    end

    @app.call(env)
  end
end

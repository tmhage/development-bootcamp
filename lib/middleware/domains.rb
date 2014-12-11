class Middleware::Domains
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)

    sanitized_url = sanitize(request.url)

    if request.url == sanitized_url
      @app.call(env)
    else
      [301, { "Location" => sanitized_url }, self]
    end
  end

  def sanitize(url)
    url.sub(/^http:\/\/(www\.)?([a-z]+\.)([a-z]{2,3})(\.[a-z0-9:]+)?(\/.*)?$/, 'http://www.\2nl\4\5')
  end
end

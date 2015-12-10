class Moneybird::Api
  def initialize(attributes = {})
    @attributes = OpenStruct.new(attributes)
  end

  def self.execute(options = {})
    options[:url] = [base_url, options.delete(:path), '.json'].join
    options = default_options.merge(options)
    result = RestClient::Request.execute(options)
    JSON.parse(result)
  rescue JSON::ParserError => e
    # Sometimes Moneybird just gives a status back
    return true if result.to_i == 200
    false
  end

  private

  def self.default_options
    {
      method: :get,
      headers: {
        Authorization: "Bearer #{ENV['MONEYBIRD_API_KEY']}"
      }
    }
  end

  def self.base_url
    ENV['MONEYBIRD_BASEURL']
  end

  def method_missing(method_sym, *arguments, &block)
    @attributes.send(method_sym)
  rescue
    super
  end
end

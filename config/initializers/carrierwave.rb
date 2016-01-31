require 'carrierwave'

CarrierWave.configure do |config|
  config.enable_processing = true unless Rails.env.test?
  if Rails.env.production?
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'] || 'xxx',
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'] || 'xxx',
      region: 'eu-west-1',
    }
    config.fog_directory = 'development-bootcamp-assets'
  end
end

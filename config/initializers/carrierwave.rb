carrierwave_config_path = Rails.root.join('config', 'carrierwave.yml')
carrierwave_config = YAML.load(ERB.new(File.read(carrierwave_config_path)).result)[Rails.env]

CarrierWave.configure do |config|
  carrierwave_config.each do |param, value|
    config.send(param, value)
  end
end

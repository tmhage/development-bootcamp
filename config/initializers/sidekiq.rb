require 'celluloid'
require 'sidekiq'
require 'sidekiq/processor'

if ENV['REDIS_URL'].present?
  Sidekiq.redis = { url: ENV['REDIS_URL'] }
end

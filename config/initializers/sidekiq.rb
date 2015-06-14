require 'celluloid'
require 'sidekiq'
require 'sidekiq/processor'

Sidekiq.redis = { url: ENV['REDIS_URL'] }

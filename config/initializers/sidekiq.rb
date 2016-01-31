require 'sidekiq'
require 'sidekiq/web'
require 'sidekiq/processor'

if ENV['REDIS_URL'].present?
  Sidekiq.redis = { url: ENV['REDIS_URL'] }
end

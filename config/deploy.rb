# config valid only for Capistrano 3.1
lock '3.2.1'
set :application, 'DevelopmentBootcamp'
set :repo_url, 'git@github.com:devbootcamps/website.git'

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :deploy_to, '/home/deploy/development_bootcamp'
set :scm, :git

set :format, :pretty
# set :log_level, :debug
set :pty, true

# set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 5

before "deploy:symlink:release", "bundle:install"
before "deploy:symlink:release", "assets:precompile"
before "deploy:symlink:release", "database:migrate"
after  "deploy:symlink:release", "deploy:restart"

namespace :bundle do
  task :install do
    on roles(:app) do
      execute "cd #{release_path} && bundle install \
        --without development test \
        --deployment"
    end
  end
end

namespace :assets do
  task :precompile do
    on roles(:app) do
      execute "source ~/.profile && \
        cd #{release_path} && \
        RAILS_ENV=production bundle exec rake assets:precompile; true"
    end
  end
end

namespace :database do
  task :migrate do
    on roles(:db) do
      execute "source ~/.profile && \
        cd #{release_path} && \
        RAILS_ENV=production bundle exec rake db:migrate --trace"
    end
  end
end

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :finishing, 'deploy:cleanup'
end

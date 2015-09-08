namespace :deploy do
  desc "Notify Appsignal of a deploy"
  task :notify do
    `bin/notify_appsignal -a DevelopmentBootcamp`
  end
end

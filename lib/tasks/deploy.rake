namespace :deploy do
  desc "Notify Appsignal of a deploy"
  task :notify, [:user] do |t, args|
    args.with_defaults(user: `whoami`.chomp)
    puts "bin/notify_appsignal -a DevelopmentBootcamp -d #{args[:user]}"
  end
end

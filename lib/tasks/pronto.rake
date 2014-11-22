namespace :pronto do
  desc 'runs pronto'
  task run: :environment do
    Pronto.gem_names.each { |gem_name| require "pronto/#{gem_name}" }

    formatter = Pronto::Formatter::GithubFormatter.new
    Pronto.run('origin/master', '.', formatter)
  end
end

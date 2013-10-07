# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

GnipSearchDemo::Application.load_tasks

require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:cucumber) do |t|
   t.cucumber_opts = "--format pretty"
end
Cucumber::Rake::Task.new(:cucumberci) do |t|
   t.cucumber_opts = "--format json"
end

task default: :spec
task test: [:spec, :cucumber, 'spec:javascript']

migration_task = task 'db:migrate'
migration_task.clear_actions
task 'db:migrate' do
   $stderr.puts 'Not running migrations.. This Application does not talk to a Database.'
end

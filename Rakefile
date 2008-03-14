# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'


namespace :ferret do
  desc "Rebuild all Indexes"
  task :rebuild_all_indexes => [:environment] do
    %w(Department Course CourseSection).each { |s| s.constantize.rebuild_index }
  end
end


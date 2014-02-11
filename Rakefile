require 'bundler/setup'

task :travis  => ['test:travis', 'coveralls_push_workaround']


require "tasks/test_task"
Fog::Rake::TestTask.new

namespace :test do
  mock = 'true' || ENV['FOG_MOCK']
  task :travis do
    # jruby coveralls causes an OOM in travis
    ENV['COVERAGE'] = 'false' if RUBY_PLATFORM == 'java'
    sh("export FOG_MOCK=#{mock} && bundle exec shindont")
  end
end

#require "tasks/changelog_task"
#Fog::Rake::ChangelogTask.new
task :coveralls_push_workaround do
  use_coveralls = (Gem::Version.new(RUBY_VERSION) > Gem::Version.new('1.9.2'))
  if (ENV['COVERAGE'] != 'false') && use_coveralls
    require 'coveralls/rake/task'
    Coveralls::RakeTask.new
    Rake::Task["coveralls:push"].invoke
  end
end

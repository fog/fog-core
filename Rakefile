require 'bundler/setup'

task :travis  => ['test:travis', 'coveralls_push_workaround']
task :default => [:test]

require "rake/testtask"


Rake::TestTask.new do |t|
  t.libs << "lib"
  t.libs << "spec"
  t.pattern = "spec/**/*_spec.rb"
end

namespace :test do
  mock = 'true' || ENV['FOG_MOCK']
  task :travis do
    # jruby coveralls causes an OOM in travis
    ENV['COVERAGE'] = 'false' if RUBY_PLATFORM == 'java'
    sh("export FOG_MOCK=#{mock} && rake")
  end
end

#require "tasks/changelog_task"
#Fog::Rake::ChangelogTask.new
task :coveralls_push_workaround do
  use_coveralls = (Gem::Version.new(RUBY_VERSION.dup) > Gem::Version.new('1.9.2'))
  if (ENV['COVERAGE'] != 'false') && use_coveralls
    require 'coveralls/rake/task'
    Coveralls::RakeTask.new
    Rake::Task["coveralls:push"].invoke
  end
end

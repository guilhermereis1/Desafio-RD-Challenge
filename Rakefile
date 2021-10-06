require 'rake/testtask'

desc 'Run unit tests'
Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.pattern = 'tests/*_test.rb'
  t.verbose = true
end
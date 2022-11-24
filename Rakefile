require 'rspec/core/rake_task'

# make sure English locale is used
ENV["LC_ALL"] = "en_US.UTF-8"
ENV["LANG"] = "en_US.UTF-8"

RSpec::Core::RakeTask.new(:test) do |t|
  t.pattern = Dir.glob('spec/*_spec.rb')
end

task :default => :test

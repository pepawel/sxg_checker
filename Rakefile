# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

require "standard/rake"

task default: %i[spec standard]

Rake::Task.define_task :validate_loader do
  abort "Basic loader is stale, run `bin/loader generate` to fix" unless system("bin/loader validate")
end

Rake::Task[:build].enhance [:validate_loader]

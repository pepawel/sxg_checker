# frozen_string_literal: true

require "sxg_checker/version"

if defined? SxgChecker::AUTOLOADERS
  require "zeitwerk"
  SxgChecker::AUTOLOADERS << Zeitwerk::Loader.for_gem.tap do |loader|
    loader.ignore("#{__dir__}/basic_loader.rb")
    loader.setup
  end
else
  require "basic_loader"
end

module SxgChecker
  Error = Class.new(StandardError)
  InvalidUrl = Class.new(Error)
  ToolNotFound = Class.new(Error)

  DUMP_BINARY = "#{ENV["HOME"]}/go/bin/dump-signedexchange"
end

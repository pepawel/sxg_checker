# frozen_string_literal: true

require 'sxg_checker/version'

if defined? SxgChecker::AUTOLOADERS
  require 'zeitwerk'
  SxgChecker::AUTOLOADERS << Zeitwerk::Loader.for_gem.tap do |loader|
    loader.ignore("#{__dir__}/basic_loader.rb")
    loader.setup
  end
else
  require 'basic_loader'
end

module SxgChecker
  InvalidUrl = Class.new(StandardError)
end

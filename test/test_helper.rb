require "minitest/autorun"
require "pry-byebug"

if false # ENV['CI']
  require 'simplecov'
  SimpleCov.start

  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

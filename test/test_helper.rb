require "minitest/autorun"
require "pry-byebug"

if ENV['CI']
  require "coveralls"
  Coveralls.wear!
end

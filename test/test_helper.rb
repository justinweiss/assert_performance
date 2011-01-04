require 'assert_performance'
require 'test/unit'

# Make Test::Unit run the same under 1.9 as 1.8.x
unless defined?(Test::Unit::AssertionFailedError)
  Test::Unit::AssertionFailedError = MiniTest::Assertion
end

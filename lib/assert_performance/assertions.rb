module AssertPerformance

  # Provides methods for asserting the performance characteristics of
  # a block of code. This module should be included in the test case
  # that is to use these assertions.
  module Assertions

    # Verify the performance characteristics of a block of
    # code. Currently supports the following options:
    #
    # <tt>:max_queries</tt>:: Maximum number of activerecord queries run
    # <tt>:time</tt>:: Maximum amount of time the method can use, measured with Time.now
    def assert_performance(options = nil, &block)
      if !options
        assert_with_custom_message false, "options must be passed to assert_performance"
      else
        options.each do |key, value|
          case key
          when :max_queries
            require 'assert_performance/activerecord_extensions'
            assert_max_queries(value, &block)
          when :max_time
            assert_max_wall_time(value, &block)
          end
        end
      end
    end

    # Asserts that no more than +max_query_count+ queries are called
    # while running +block+.
    def assert_max_queries(max_query_count, &block)
      old_count = ::ActiveRecord::Base.statement_count
      block.call
      count = ::ActiveRecord::Base.statement_count
      assert_with_custom_message((count - old_count) <= max_query_count, "Expected #{max_query_count} queries max, but executed #{count - old_count}")
    end

    # Asserts that no more than +max_time_in_ms+ milliseconds pass
    # while running +block+.
    def assert_max_wall_time(max_time_in_ms, &block)
      start_time = Time.now.to_f * 1000
      block.call
      end_time = Time.now.to_f * 1000
      
      assert_with_custom_message((end_time - start_time) <= max_time_in_ms, "Expected block to take #{max_time_in_ms} ms max, but it took #{end_time - start_time} ms")
    end
    
    private
    
    # In Test::Unit, +assert_block+ displays only the message on a test
    # failure and +assert+ always appends a message to the end of the
    # passed-in assertion message. In MiniTest, it's the other way
    # around. This abstracts those differences and never appends a
    # message to the one the user passed in.
    def assert_with_custom_message(value, message = nil)
      if defined?(MiniTest::Assertions)
        assert value, message
      else
        assert_block message do
          value
        end
      end
    end
    
  end
end

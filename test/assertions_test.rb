require 'test_helper'
require 'active_record'

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => "test/db/db.sqlite3")

class Person < ActiveRecord::Base
end

class AssertionsTest < Test::Unit::TestCase
  include AssertPerformance::Assertions

  def test_failure_when_options_not_passed
    assert_raise Test::Unit::AssertionFailedError do
      assert_performance do
        x = 1
      end
    end
  end

  def test_assert_performance_with_sql_passes
    Person.find_by_id(1) # prime the db
    assert_nothing_raised do
      assert_performance :max_queries => 1 do
        Person.find_by_id(1)
      end
    end
  end

  def test_assert_performance_with_sql_fails
    Person.find_by_id(1) # prime the db
    assert_raise Test::Unit::AssertionFailedError do
      assert_performance :max_queries => 1 do
        Person.find_by_id(1)
        Person.find_by_id(2)
      end
    end
  end
  
  def test_assert_performance_with_time_passes
    assert_nothing_raised do
      assert_performance :max_time => 2000 do
        x = 1
      end
    end
  end

  def test_assert_performance_with_time_failure
    assert_raise Test::Unit::AssertionFailedError do
      assert_performance :max_time => 500 do
        sleep 1
        x = 1
      end
    end
  end
end

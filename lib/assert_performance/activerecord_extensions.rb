require 'active_record'

# Extensions to ActiveRecord to support query count tracking.
module ::AssertPerformance::ActiveRecord
  # Extensions to whichever ActiveRecord connection is active, to add
  # a +statement_count+ accessor and a wrapper to increment the
  # statement count on execution.
  module ConnectionExtensions

    # Methods mixed into the ActiveRecord::Base::Connection class.
    module ClassMethods

      # The total number of statements that this connection has executed
      def statement_count
        @@statement_count ||= 0
      end

      # Manually set +statement_count+ to +value+
      def statement_count=(value)
        @@statement_count = value
      end
    end

    # Execute +sql+, keeping track of the total number of sql queries
    # this connection has executed.
    def execute_with_sql_counter(sql, name = nil, skip_logging = false)
      self.class.statement_count += sql.split(';').reject {|s| s.blank?}.length
      execute_without_sql_counter(sql, name) #arity?
    end

    def self.included(klass)
      klass.extend(ClassMethods)
      klass.alias_method_chain :execute, :sql_counter
    end
  end

  # Extensions to ActiveRecord::Base that add a +statement_count+
  # accessor that delegates to its connection, to make it easier to
  # access.
  module BaseExtensions
    
    # Methods mixed into the ActiveRecord::Base class
    module ClassMethods

      # The number of statements that +connection+ has executed
      def statement_count
        connection.class.statement_count
      end
    end

    def self.included(klass)
      klass.extend(ClassMethods)
    end
  end
end

::ActiveRecord::Base.connection.class.send(:include, ::AssertPerformance::ActiveRecord::ConnectionExtensions)
::ActiveRecord::Base.send(:include, ::AssertPerformance::ActiveRecord::BaseExtensions)

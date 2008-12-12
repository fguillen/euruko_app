module Rathole
  module Extensions
    module ActiveRecord
      module ConnectionAdapters
        module SQLiteAdapter
          def disable_referential_integrity(&block)
            yield
          end          
        end
      end
    end
  end
end

unless ActiveRecord::ConnectionAdapters.const_defined?("SQLiteAdapter")
  require "active_record/connection_adapters/sqlite_adapter"
  require "active_record/connection_adapters/sqlite3_adapter"
end

ActiveRecord::ConnectionAdapters::SQLiteAdapter.send(:include,
  Rathole::Extensions::ActiveRecord::ConnectionAdapters::SQLiteAdapter)

ActiveRecord::ConnectionAdapters::SQLite3Adapter.send(:include,
  Rathole::Extensions::ActiveRecord::ConnectionAdapters::SQLiteAdapter)

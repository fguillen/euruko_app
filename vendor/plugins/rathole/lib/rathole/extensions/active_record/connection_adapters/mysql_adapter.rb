require "active_record/connection_adapters/mysql_adapter"

module Rathole
  module Extensions
    module ActiveRecord
      module ConnectionAdapters
        module MysqlAdapter
          def disable_referential_integrity(&block)
            begin
              # TODO: don't turn FK checks back on unless they were originally
              update("SET FOREIGN_KEY_CHECKS = 0")
              yield
            ensure
              update("SET FOREIGN_KEY_CHECKS = 1")              
            end
          end          
        end
      end
    end
  end
end

ActiveRecord::ConnectionAdapters::MysqlAdapter.send(:include,
  Rathole::Extensions::ActiveRecord::ConnectionAdapters::MysqlAdapter)

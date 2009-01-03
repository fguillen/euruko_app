module GreenRiver #:nodoc:
  module FindRandom #:nodoc:

    def self.included(base) #:nodoc:
      base.extend SingletonMethods
    end

    module SingletonMethods #:nodoc:
      # Item.random(5, :conditions => ...)
      def random(*args)
        limit = args.first
        options = args.last.is_a?(::Hash) ? args.pop : {}
        # if only one row is requested, use the strategy of getting the size of the
        # result set, and then in a second query offset by a random int of that
        case limit
        when 0
          []
        when 1
          result_size = count(options)
          offset = result_size == 1 ? 0 : rand(result_size - 1)
          find(:first, options.merge(:offset => offset))
        else
          options[:select] = primary_key
          options.delete(:limit)
          options.delete(:order)
          sql = construct_finder_sql(options)
          all_ids = connection.select_all(sql, "#{name} Load IDs (find_random plugin)").collect!{|r| r['id']} 
          find(Array.new([limit, all_ids.length].min){|i| all_ids.delete_at(rand(all_ids.length - 1))})
        end
      end
    end
  end
end
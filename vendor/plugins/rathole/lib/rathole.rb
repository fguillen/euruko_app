module Rathole
  mattr_writer :delete_incrementally
  @@delete_incrementally = true
  
  class << self    
    # Will rathole truncate tables as it goes? Defaults to +true+. Set
    # +delete_incrementally+ to false if you're using alternative
    # methods to clean out your test database.
    def delete_incrementally?
      @@delete_incrementally
    end
  end
end

require File.dirname(__FILE__) + '/lib/green_river/find_random'
ActiveRecord::Base.send :include, GreenRiver::FindRandom

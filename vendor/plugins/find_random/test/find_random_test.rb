require 'test_helper'

class FrUser < ActiveRecord::Base
end

class FindRandomTest < Test::Unit::TestCase
  fixtures :fr_users
  
  def test_size_of_found_collection
    assert_equal 4, FrUser.random(4).size
  end

  def test_found_collection_random
    srand(14)
    rand_users = FrUser.random(3)
    assert_equal 'matilda', rand_users[0].login
    assert_equal 'silvia', rand_users[1].login
    assert_equal 'leon', rand_users[2].login
  end

  def test_finding_single_random_row
    srand(8)
    assert_equal 'patricia', FrUser.random(1).login
  end
  def test_finding_single_random_row_with_conditions
    srand(9)
    assert_equal 'matilda', FrUser.random(1, :conditions => 'login LIKE "%il%"').login
  end
end

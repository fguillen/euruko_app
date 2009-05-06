require File.dirname(__FILE__) + '/../test_helper'

class FactoryGirlTest < ActiveSupport::TestCase
  def test_counting_1
    Factory(:room)
    # puts "counting_1: #{Room.count}"
  end
  
  def test_counting_2
    Factory(:room)
    # puts "counting_2: #{Room.count}"
  end
end
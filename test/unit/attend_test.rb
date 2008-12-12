require File.dirname(__FILE__) + '/../test_helper'

class AttendTest < ActiveSupport::TestCase
  # fixtures :all
  def test_relations
    @vote = votes(:vote1)
    assert_equal( users(:user1), @vote.user )
  end
end

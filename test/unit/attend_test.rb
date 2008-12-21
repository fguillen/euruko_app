require File.dirname(__FILE__) + '/../test_helper'

class AttendTest < ActiveSupport::TestCase
  
  def setup
    @attend = attends(:user1_go_paper1)
    @user = users(:user1)
    @paper = papers(:paper1)
  end
  
  def test_relations
    assert_equal( @user, @attend.user )
    assert_equal( @paper, @attend.paper )
  end
  
  def test_create
    assert_difference "Attend.count", 1 do
      Attend.create(:user => @user, :paper => papers(:paper2))
    end
  end
  
  def test_destroy
    assert_difference "Attend.count", -1 do
      @attend.destroy
    end
  end
  
  def test_foreign_keys
    assert_raise(ActiveRecord::StatementInvalid) do
      Attend.create(:user => @user, :paper_id => 23)
    end
    
    assert_raise(ActiveRecord::StatementInvalid) do
      Attend.create(:user_id => 23, :paper => @paper)
    end
  end
  
  def test_uniqueness
    assert_difference "Attend.count", 0 do
      Attend.create(
        :user     => @user,
        :paper    => @paper
      )
    end
  end
  
  def test_validations
    attend = Attend.new(:paper => @paper)
    assert( !attend.valid? )
    assert( attend.errors.on(:user_id) )
    assert( !attend.errors.on(:paper_id) )
    
    attend = Attend.new(:user => @user)
    assert( !attend.valid? )
    assert( !attend.errors.on(:user_id) )
    assert( attend.errors.on(:paper_id) )

    attend = Attend.new(:user => @user, :paper => @paper)
    assert( attend.valid? )
  end
end

require File.dirname(__FILE__) + '/../test_helper'

# has_many :speakers
# has_many :user_speakers, :through => :speakers, :source => :user
# has_many :comments
# has_many :resources
# has_many :attends
# has_many :attendents, :through => :attendents, :source => :user
# 
# belongs_to :room

# t.string      :title, :null => false, :limit => 255
# t.text        :description
# t.string      :paper_type,    :null => false
# t.string      :paper_status,  :null => false
# t.datetime    :date
# t.integer     :minutes, :default => -1, :null => false
# t.integer     :room_id

class PaperTest < ActiveSupport::TestCase
  def setup
    @paper = papers(:paper1)
    @user = users(:user1)
  end

  def test_relations
    assert_equal( @user, @paper.user_speakers[0] )
    assert( @paper.comments.include?(comments(:comment1)) )
    assert( @paper.resources.include?(resources(:resource1)) )
    assert( @paper.attendents.include?(@user) )
  end

  def test_create
    assert_difference "Paper.count", 1 do
      Paper.create(
        :title        => @paper.title,
        :description  => @paper.description,
        :type         =>  @paper.type,
        :status       => @paper.status
      )
    end
  end

  def test_destroy_with_attends_should_destroy_attends
    assert_difference "Attend.count", -1 do
      assert_difference "Paper.count", -1 do
        @paper.destroy
      end
    end
  end


  def test_destroy_without_payments
    @paper = Paper.create(:name => 'paper', :description => 'description')
    
    assert_difference "Paper.count", -1 do
      @paper.destroy
    end
  end

  def test_foreign_keys
  end

  def test_validations
    paper = Paper.new()
    assert( !paper.valid? )
    assert( paper.errors.on(:name) )
    assert( paper.errors.on(:description) )
    
    paper = Paper.new(:name => 'paper', :description => 'description')
    assert( paper.valid? )
  end
end

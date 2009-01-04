require File.dirname(__FILE__) + '/../test_helper'

# has_many :speakers
# has_many :user_speakers, :through => :speakers, :source => :user
# has_many :comments
# has_many :resources
# has_many :attendees
# has_many :attendees, :through => :attendees, :source => :user
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
    assert_equal( @user, @paper.speakers[0].user )
    assert( @paper.comments.include?(comments(:comment1)) )
    assert( @paper.resources.include?(resources(:resource1)) )
    assert( @paper.attendees.collect{ |a| a.user }.include?(@user) )
  end

  def test_create
    assert_difference "Paper.count", 1 do
      Paper.create(
        :title        => @paper.title,
        :description  => @paper.description,
        :family       => @paper.family,
        :status       => @paper.status,
        :minutes      => 0
      )
    end
  end

  def test_destroy_with_attendees_should_destroy_attendees
    assert_difference "Attendee.count", -2 do
      assert_difference "Paper.count", -1 do
        @paper.destroy
      end
    end
  end
  
  def test_destroy_with_resources_should_destroy_resources
    assert_difference "Resource.count", -2 do
      assert_difference "Paper.count", -1 do
        @paper.destroy
      end
    end
  end
  
  def test_destroy_with_votes_should_destroy_votes
    assert_difference "Vote.count", -2 do
      assert_difference "Paper.count", -1 do
        @paper.destroy
      end
    end
  end
  
  def test_destroy_with_speakers_should_destroy_speakers
    assert_difference "Speaker.count", -1 do
      assert_difference "Paper.count", -1 do
        @paper.destroy
      end
    end
  end
  
  
  def test_destroy_with_comments_should_destroy_comments
    assert_difference "Comment.count", -2 do
      assert_difference "Paper.count", -1 do
        @paper.destroy
      end
    end
  end

  def test_validations
    paper = Paper.new()
    assert( !paper.valid? )
    assert( paper.errors.on(:title) )
    assert( paper.errors.on(:description) )
    assert( paper.errors.on(:family) )
    assert( paper.errors.on(:status) )
    
    paper = 
      Paper.new(
        :title        => @paper.title,
        :description  => @paper.description,
        :family       => @paper.family,
        :status       => @paper.status,
        :minutes      => @paper.minutes
      )
    assert( paper.valid? )
  end
  
  def test_add_speaker
    assert_difference "Speaker.count", 1 do
      @paper.add_speaker( users(:user2) )
      @paper.save
    end
    
    
  end
  
  def test_should_update_date_on_save_when_date_form_and_time_form
    @paper = 
      Paper.new(
        :title        => @paper.title,
        :description  => @paper.description,
        :family       => @paper.family,
        :status       => @paper.status,
        :minutes      => @paper.minutes
      )
    
    assert_nil( @paper.date )
    
    @paper.save
    assert_nil( @paper.date )
    
    @paper.update_attributes(
      :date_form => '2009/01/01',
      :time_form => '10:10'
    )
    
    assert_not_nil( @paper.date )
    
    # TODO: what happend with this date?
    # assert_equal( '2009/01/01 10:10', @paper.date.strftime( "%Y/%m/%d %H:%M" ) )
  end
  
  def test_should_return_date_form_and_time_form_from_date
    assert_not_nil( @paper.date )
    assert_not_nil( @paper.date_form )
    assert_not_nil( @paper.time_form )
    
    @paper.update_attributes( :date => nil )
    assert_nil( @paper.date_form )
    assert_nil( @paper.time_form )
    
    @paper.update_attributes( :date => Time.parse( "2009/12/30 10:11" ) )
    assert_equal( '2009/12/30', @paper.date_form )
    # TODO: what happend with this date?
    # assert_equal( '10:11', @paper.time_form )
  end
  
  def test_find_all_by_status
    num = Paper.find_all_by_status( Paper::STATUS[:CONFIRMED] ).size
    
    @paper = Paper.create(
      :title        => @paper.title,
      :description  => @paper.description,
      :family       => @paper.family,
      :status       => Paper::STATUS[:CONFIRMED],
      :minutes      => 0
    )
    
    assert_equal( num + 1, Paper.find_all_by_status( Paper::STATUS[:CONFIRMED] ).size )
    
    @paper.update_attributes( :status => Paper::STATUS[:ACEPTED] )
    assert_equal( num, Paper.find_all_by_status( Paper::STATUS[:CONFIRMED] ).size )

  end
  
  # def test_random_datetime
  #   def random_datetime( date_ini = '1970/01/01 10:10', date_end = '2010/01/01 10:10' )
  #     time_ini_int = Time.parse( date_ini ).to_i
  #     time_end_int = Time.parse( date_end ).to_i
  # 
  #     time_random_int = Kernel.rand( time_end_int - time_ini_int ) + time_ini_int
  # 
  #     return Time.at( time_random_int )
  #   end
  # 
  #   (1..100).each{ |n| puts random_datetime( '2009/01/01 08:00', '2009/01/01 21:00' ) }
  #   
  # end
end

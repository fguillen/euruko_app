require File.dirname(__FILE__) + '/../test_helper'

class PhotoTest < ActiveSupport::TestCase
  def test_geometry_validations
    @paper = papers(:paper1)
    Paper.validates_attachment_width :photo, :greater_than => 576, :less_than => 1000
    Paper.validates_attachment_height :photo, :greater_than => 150, :less_than => 300
    @paper.photo = File.new( "#{RAILS_ROOT}/test/fixtures/photos/photo50x30.png" )
    assert( !@paper.valid? )
    # puts "XXX1: #{@paper.errors.full_messages}"
    
    Paper.validates_attachment_width :photo, :greater_than => 49, :less_than => 51
    Paper.validates_attachment_height :photo, :greater_than => 29, :less_than => 31
    @paper.photo = File.new( "#{RAILS_ROOT}/test/fixtures/photos/photo50x30.png" )
    assert( @paper.valid? )
    # puts "XXX2: #{@paper.errors.full_messages}"

    Paper.validates_attachment_width :photo, :greater_than => 50, :less_than => 50
    Paper.validates_attachment_height :photo, :greater_than => 30, :less_than => 30
    @paper.photo = File.new( "#{RAILS_ROOT}/test/fixtures/photos/photo50x30.png" )
    assert( @paper.valid? )
    # puts "XXX3: #{@paper.errors.full_messages}"
    
    Paper.validates_attachment_width :photo, :less_than => 50
    Paper.validates_attachment_height :photo, :less_than => 30
    @paper.photo = File.new( "#{RAILS_ROOT}/test/fixtures/photos/photo50x30.png" )
    assert( @paper.valid? )
    # puts "XXX4: #{@paper.errors.full_messages}"
    
    Paper.validates_attachment_width :photo, :less_than => 49
    Paper.validates_attachment_height :photo, :less_than => 30
    @paper.photo = File.new( "#{RAILS_ROOT}/test/fixtures/photos/photo50x30.png" )
    assert( !@paper.valid? )
    # puts "XXX5: #{@paper.errors.full_messages}"
    
    Paper.validates_attachment_width :photo, :less_than => 50
    Paper.validates_attachment_height :photo, :less_than => 29
    @paper.photo = File.new( "#{RAILS_ROOT}/test/fixtures/photos/photo50x30.png" )
    assert( !@paper.valid? )
    # puts "XXX6: #{@paper.errors.full_messages}"
    
    Paper.validates_attachment_width :photo, :greater_than => 50
    Paper.validates_attachment_height :photo, :greater_than => 30
    @paper.photo = File.new( "#{RAILS_ROOT}/test/fixtures/photos/photo50x30.png" )
    assert( @paper.valid? )
    # puts "XXX7: #{@paper.errors.full_messages}"
    
    Paper.validates_attachment_width :photo, :greater_than => 51
    Paper.validates_attachment_height :photo, :greater_than => 30
    @paper.photo = File.new( "#{RAILS_ROOT}/test/fixtures/photos/photo50x30.png" )
    assert( !@paper.valid? )
    # puts "XXX8: #{@paper.errors.full_messages}"
    
    Paper.validates_attachment_width :photo, :greater_than => 50
    Paper.validates_attachment_height :photo, :greater_than => 31
    @paper.photo = File.new( "#{RAILS_ROOT}/test/fixtures/photos/photo50x30.png" )
    assert( !@paper.valid? )
    # puts "XXX9: #{@paper.errors.full_messages}"
    
    Paper.validates_attachment_width :photo, :in => 10..100
    Paper.validates_attachment_height :photo, :in => 10..100
    @paper.photo = File.new( "#{RAILS_ROOT}/test/fixtures/photos/photo50x30.png" )
    assert( @paper.valid? )
    # puts "XXX10: #{@paper.errors.full_messages}"
    
    Paper.validates_attachment_width :photo, :in => 60..100
    Paper.validates_attachment_height :photo, :in => 80..100
    @paper.photo = File.new( "#{RAILS_ROOT}/test/fixtures/photos/photo50x30.png" )
    assert( !@paper.valid? )
    # puts "XXX10: #{@paper.errors.full_messages}"
  end
  
end
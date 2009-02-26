require File.dirname(__FILE__) + '/../test_helper'

class ResourceTest < ActiveSupport::TestCase
  def setup
    @resource = resources(:resource1)
    @user = users(:user1)
    @paper = papers(:paper1)
  end

  def test_relations
    assert_equal( @user, @resource.user )
    assert_equal( @paper, @resource.paper )
  end

  def test_create
    assert_difference "Resource.count", 1 do
      Resource.create(
        :user => @user, 
        :paper => @paper, 
        :url => 'http://mi.url'
      )
    end
  end

  def test_destroy
    assert_difference "Resource.count", -1 do
      @resource.destroy
    end
  end

  def test_validations
    resource = Resource.new()
    assert( !resource.valid? )
    assert( resource.errors.on(:user_id) )
    assert( resource.errors.on(:paper_id) )
    assert( resource.errors.on(:url) )

    resource = 
      Resource.new(
        :user => @resource.user, 
        :paper => @resource.paper, 
        :url => @resource.url
      )
    assert( !resource.valid? )
    assert( !resource.errors.on(:user_id) )
    assert( !resource.errors.on(:paper_id) )
    assert( resource.errors.on(:url) )
    
    resource = 
      Resource.new(
        :user => @resource.user, 
        :paper => @resource.paper, 
        :url => 'http://otra.url'
      )
    assert( resource.valid? )
  end
  
  def test_url_link
    assert( !resources(:resource1).is_local )
    assert_equal( resources(:resource1).url, resources(:resource1).url_link )

    assert( resources(:resource2).is_local )
    assert_not_equal( resources(:resource2).url, resources(:resource2).url_link )
    assert( resources(:resource2).url_link =~ /#{APP_CONFIG[:site_domain]}/ )
  end
  
  def test_name_link
    @resource = resources(:resource1)
    assert_equal( @resource.name, @resource.name_link )

    @resource.update_attribute( :name, nil )
    assert_equal( @resource.url_link, @resource.name_link )

    @resource.update_attribute( :name, '' )
    assert_equal( @resource.url_link, @resource.name_link )
  end
  
  def test_url_validation
    @resource = 
      Resource.new(
        :is_local => false,
        :url      => 'http://web.com',
        :paper_id => papers(:paper1).id,
        :user_id  => users(:user1).id
      )
    
    @resource.valid?
    puts @resource.errors.full_messages
    assert( @resource.valid? )
    
    @resource.url = 'http://web'
    assert( !@resource.valid? )
    
    @resource.is_local = true
    assert( @resource.valid? )
  end
end

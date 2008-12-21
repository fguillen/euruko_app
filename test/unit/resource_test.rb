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

  def test_foreign_keys
    assert_raise(ActiveRecord::StatementInvalid) do
      Resource.create(:user => @user, :paper_id => -1, :url => 'http://mi.url')
    end

    assert_raise(ActiveRecord::StatementInvalid) do
      Resource.create(:user_id => -1, :paper => @paper, :url => 'http://mi.url')
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
end

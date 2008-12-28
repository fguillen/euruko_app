# t.string        :name,                  :null => false
# t.string        :login,                 :null => false
# t.string        :email,                 :null => false
# t.string        :crypted_password,                        :limit => 40
# t.string        :salt,                                    :limit => 40
# t.string        :remember_token
# t.datetime      :remember_token_expires_at
# t.string        :activation_code,                         :limit => 40
# t.datetime      :activated_at
# t.string        :role,                  :null => false

require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:user1)
    @paper = papers(:paper1)
  end

  def test_relations
    assert( @user.speaker_on.include?( @paper) )
    assert( @user.comments.include?(comments(:comment1)) )
    assert( @user.resources.include?(resources(:resource1)) )
    assert( @user.attend_to.include?(@paper) )
  end

  def test_create
    assert_difference "User.count", 1 do
      User.create!(
        :name         => @user.name,
        :login        => 'other_login',
        :email        => 'email@email.com',
        :password     => 'pass000',
        :password_confirmation => 'pass000',
        :role         => User::ROLE[:USER]
      )
    end
  end

  def test_destroy_with_attends_should_destroy_attends
    assert_difference "Attend.count", -1 do
      assert_difference "User.count", -1 do
        @user.destroy
      end
    end
  end
  
  def test_destroy_with_resources_should_destroy_resources
    assert_difference "Resource.count", -2 do
      assert_difference "User.count", -1 do
        @user.destroy
      end
    end
  end
  
  def test_destroy_with_votes_should_destroy_votes
    assert_difference "Vote.count", -1 do
      assert_difference "User.count", -1 do
        @user.destroy
      end
    end
  end
  
  def test_destroy_with_speakers_should_destroy_speakers
    assert_difference "Speaker.count", -1 do
      assert_difference "User.count", -1 do
        @user.destroy
      end
    end
  end
  
  
  def test_destroy_with_comments_should_destroy_comments
    assert_difference "Comment.count", -1 do
      assert_difference "User.count", -1 do
        @user.destroy
      end
    end
  end

  def test_foreign_keys
  end

  def test_validations
    # login uniqness
    user = 
      User.new(
        :name         => @user.name,
        :login        => @user.login,
        :email        => 'email2@email.com',
        :password     => 'pass000',
        :password_confirmation => 'pass000',
        :role         => User::ROLE[:USER]
      )
    
    assert( !user.valid? )
    assert( user.errors.on(:login) )
  end
  
  def test_admin
    @user = users(:user1)
    assert( !@user.admin? )
    
    @user.role = User::ROLE[:ADMIN]
    assert( @user.admin? )
  end
end

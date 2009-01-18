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
    assert( @user.attendee_to.include?(@paper) )
  end

  def test_create
    assert_difference "User.count", 1 do
      User.create(
        :name                   => 'User Name',
        :login                  => 'other_login',
        :email                  => 'email@email.com',
        :password               => 'pass000',
        :password_confirmation  => 'pass000',
        :public_profile         => true
      )
    end
  end
  
  def test_create_with_public_profile_false
    assert_difference "User.count", 1 do
      User.create(
        :name                   => 'User Name',
        :login                  => 'other_login',
        :email                  => 'email@email.com',
        :password               => 'pass000',
        :password_confirmation  => 'pass000',
        :public_profile         => false
      )
    end
  end
  
  def test_update
    @user = users(:user1)
    @user.update_attributes(
      :name                   => 'other name',
      :login                  => 'other_login',
      :email                  => 'other_email@email.com',
      :password               => 'other_pass',
      :password_confirmation  => 'other_pass',
      :public_profile         => false
    )
    
    assert_equal( 'other name', @user.name )
    assert_equal( 'other_login', @user.login )
    assert_equal( 'other_email@email.com', @user.email )
    assert_equal( 'other_pass', @user.password )
    assert_equal( false, @user.public_profile )
  end
  
  def test_update_not_update_role
    @user = users(:user1)
    
    assert_not_equal( User::ROLE[:ADMIN], @user.role )
    
    @user.update_attributes(
      :role => User::ROLE[:ADMIN]
    )
    
    assert_not_equal( !User::ROLE[:ADMIN], @user.role )
  end
  
  def test_permalink
    @user = 
      User.create(
        :name                   => 'User Name',
        :login                  => 'other_login',
        :email                  => 'email@email.com',
        :password               => 'pass000',
        :password_confirmation  => 'pass000',
        :public_profile         => true
      )
      
    assert( @user.valid? )
    assert_not_nil( @user.permalink )
    assert_equal( @user.id, @user.to_param.to_i )
  end

  def test_destroy_with_attendees_should_destroy_attendees
    assert_difference "Attendee.count", -1 do
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
        :password_confirmation => 'pass000'
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
  
  def test_find_speakers
    assert( User.find_speakers )
    assert( User.find_speakers.include?( users(:user1) ) )
    assert( !User.find_speakers.include?( users(:user2) ) )
  end
  
  def test_find_public
    assert( User.find_public )
    assert( User.find_public.include?( users(:user1) ) )
    assert( !User.find_public.include?( users(:user2) ) )
  end
  
  def test_is_speaker_on_or_admin
    assert( users(:user1).is_speaker_on_or_admin?( papers(:paper1) ) )
    assert( !users(:user2).is_speaker_on_or_admin?( papers(:paper1) ) )
    assert( users(:user_admin).is_speaker_on_or_admin?( papers(:paper1) ) )
  end
  def test_speaker_on_visibles
    @paper = papers(:paper1)
    assert( users(:user1).speaker_on_visibles_for_user( users(:user1) ) )
    assert( users(:user1).speaker_on_visibles_for_user( users(:user1) ).include?( @paper ) )
    assert( !users(:user1).speaker_on_visibles_for_user( users(:user2) ).include?( @paper ) )
    assert( !users(:user1).speaker_on_visibles_for_user( users(:user_admin) ).include?( @paper ) )

    @paper.status = Paper::STATUS[:ACEPTED]
    @paper.save!
    
    assert( users(:user1).speaker_on_visibles_for_user( users(:user2) ).include?( @paper ) )
  end
end

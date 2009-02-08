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
    
    assert( User.last.authenticated?( 'pass000' ) )
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
    @user = users(:user_not_speaker)
    @user.update_attributes!(
      :name                   => 'other name',
      :login                  => 'other_login',
      :email                  => 'other_email@email.com',
      :password               => 'other_pass',
      :password_confirmation  => 'other_pass',
      :public_profile         => false
    )
    
    @user.reload
    assert_equal( 'other name', @user.name )
    assert_equal( 'other_login', @user.login )
    assert_equal( 'other_email@email.com', @user.email )
    assert_equal( false, @user.public_profile )
  end
  
  def test_update_not_update_role
    @user = users(:user1)
    
    assert_not_equal( User::ROLE[:ADMIN], @user.role )
    
    @user.update_attributes(
      :role => User::ROLE[:ADMIN]
    )
    
    @user.reload
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
  
  def test_destroy_with_carts_should_destroy_carts
    assert_difference "Cart.count", -3 do
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
    assert_difference "Speaker.count", -2 do
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
    
  def test_public_profile
    assert( User.public_profile )
    assert( User.public_profile.include?( users(:user1) ) )
    assert( !User.public_profile.include?( users(:private) ) )
  end
  
  def test_is_speaker_on_or_admin
    assert( users(:user1).is_speaker_on_or_admin?( papers(:paper1) ) )
    assert( !users(:user2).is_speaker_on_or_admin?( papers(:paper1) ) )
    assert( users(:user_admin).is_speaker_on_or_admin?( papers(:paper1) ) )
  end
  def test_speaker_on_visibles
    @paper = papers(:paper3)
    assert( users(:user1).speaker_on_visibles_for_user( users(:user1) ) )
    assert( users(:user1).speaker_on_visibles_for_user( users(:user1) ).include?( @paper ) )
    assert( !users(:user1).speaker_on_visibles_for_user( users(:user2) ).include?( @paper ) )
    assert( !users(:user1).speaker_on_visibles_for_user( users(:user_admin) ).include?( @paper ) )

    @paper.status = Paper::STATUS[:ACEPTED]
    @paper.save!
    
    assert( users(:user1).speaker_on_visibles_for_user( users(:user2) ).include?( @paper ) )
  end
  
  def test_speakers_cant_set_profile_to_private
    user = Speaker.first.user
    user.public_profile = false
    assert !user.valid?
    assert user.errors.on(:public_profile)
  end
  
  def test_speakers_finder_returns_unique_users
    assert_equal(
      User.public_speaker.uniq, 
      User.public_speaker
    )
  end

  def test_speakers_finder_doesnt_return_users_without_accepted_papers
    Paper.all.each{ |p| p.status = Paper::STATUS[:PROPOSED]; p.save }
    assert_equal [], User.public_speaker
  end
  
  def test_update_password
    @user = users(:user1)
    assert( !@user.authenticated?( 'otherpass' ) )
    
    @user.update_attributes!(
      :password              => 'otherpass',
      :password_confirmation => 'otherpass'
    )
    
    assert( @user.valid? )
    assert( @user.authenticated?( 'otherpass' ) )
  end
  
  def test_on_create_role_should_be_user
    @user =
      User.create(
        :name                   => 'User Name',
        :login                  => 'other_login',
        :email                  => 'email@email.com',
        :password               => 'pass000',
        :password_confirmation  => 'pass000',
        :public_profile         => true,
        :role                   => User::ROLE[:ADMIN]
      )
    
    assert( @user.valid? )
    assert_equal( User::ROLE[:USER], @user.role )
  end
  
  def test_named_scope_public_profile
    assert( User.public_profile )
    assert( User.public_profile.include?( users(:user1) ) )
    assert( !User.public_profile.include?( users(:private) ) )    
  end
    
  def test_named_scope_public_speaker
    assert( User.public_speaker)
    assert( User.public_speaker.include?( users(:user1) ) )
    assert( !User.public_speaker.include?( users(:user2) ) )   
  end
  
  def test_named_scope_speaker
    assert( User.speaker )
    assert( User.speaker.include?( users(:user1) ) )
    assert( User.speaker.include?( users(:user2) ) )
  end
  
  def test_speaker
    assert( users(:user1).speaker? )
    assert( !users(:user_not_speaker).speaker? )
  end
  
  def test_everything_paid
    assert( !users(:user1).everything_paid? )
    @user = users(:user_everything_paid)
    assert( @user.everything_paid? )

    @event =
      Event.create(
        :name => 'event', 
        :description => 'description'
      )
    assert( @event.valid? )
    assert( !@user.everything_paid? )
    
    @event.destroy
    assert( @user.everything_paid? )
    
    @user.carts.destroy_all
    assert( !@user.everything_paid? )
  end
end

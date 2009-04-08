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
      :public_profile         => false,
      :location_name          => 'location_name_wadus',
      :location_country       => 'location_country_wadus',
      :invoice_info           => 'other invoice info'
    )
    
    @user.reload
    assert_equal( 'other name', @user.name )
    assert_equal( 'other_login', @user.login )
    assert_equal( 'other_email@email.com', @user.email )
    assert_equal( false, @user.public_profile )
    assert_equal( 'location_name_wadus', @user.location_name )
    assert_equal( 'location_country_wadus', @user.location_country )
    assert_equal( 'other invoice info', @user.invoice_info )
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
    assert( user.errors.on(:name) )
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
  
  def test_urls_validations
    @user = users(:user1)
    @user.personal_web_url = nil
    @user.company_url = nil
    assert( @user.valid? )
    
    @user.personal_web_url = 'http://web.com'
    @user.company_url = 'http://web.com'
    assert( @user.valid? )

    @user.personal_web_url = 'http://web'
    @user.company_url = 'http://web.com'
    assert( !@user.valid? )
    assert( @user.errors.on(:personal_web_url) )
    assert( !@user.errors.on(:company_url) )
    
    @user.personal_web_url = 'http://web.co/web/web.php'
    @user.company_url = 'http://web'
    assert( !@user.valid? )
    assert( !@user.errors.on(:personal_web_url) )
    assert( @user.errors.on(:company_url) )
    
    @user.personal_web_url = ''
    @user.company_url = nil
    assert( @user.valid? )
    assert( !@user.errors.on(:personal_web_url) )
    assert( !@user.errors.on(:company_url) )
  end
  
  def test_validation_user_should_has_a_personal_web_url_if_personal_web_name_defined
    @user = users(:user1)
    @user.personal_web_name = nil
    @user.personal_web_url = nil
    assert( @user.valid? )

    @user.personal_web_name = "myweb"
    assert( !@user.valid? )
    assert( @user.errors.on(:personal_web_url) )
    
    @user.personal_web_url = "http://myweb.com"
    assert( @user.valid? )
  end
  
  def test_on_create_should_send_an_email_with_notification_recipients_as_bcc
    ActionMailer::Base.deliveries = []
    
    assert( ActionMailer::Base.deliveries.empty? )
    
    @user = 
      User.create(
        :name                   => 'User Name',
        :login                  => 'other_login',
        :email                  => 'email@email.com',
        :password               => 'pass000',
        :password_confirmation  => 'pass000',
        :public_profile         => true
      )
      
    assert( !ActionMailer::Base.deliveries.empty? )
    sent = ActionMailer::Base.deliveries.last
    
    assert_equal( APP_CONFIG[:email_notification_recipients], sent.bcc )
  end
  
  def test_github_user_and_twitter_user
    @user = users(:user1)
    
    assert_not_equal( "wadus_github", @user.github_user )
    assert_not_equal( "wadus_twitter", @user.twitter_user )
    
    @user.update_attributes(
      :github_user    => 'wadus_github',
      :twitter_user   => 'wadus_twitter'
    )
    
    @user.reload
    assert_equal( "wadus_github", @user.github_user )
    assert_equal( "wadus_twitter", @user.twitter_user )
  end
  
  # def test_on_new_with_name_already_exits_should_catch_the_error
  #   
  #   assert_difference "User.count", 0 do
  #     @user =
  #       User.create(
  #         :name                   => users(:user1).name,
  #         :login                  => 'other_login',
  #         :email                  => 'email@email.com',
  #         :password               => 'pass000',
  #         :password_confirmation  => 'pass000',
  #         :public_profile         => true,
  #         :role                   => User::ROLE[:ADMIN]
  #       )
  #   end
  # 
  #   
  #   assert( @user.valid? )
  #   assert_equal( User::ROLE[:USER], @user.role )
  # end
  
  def test_named_scope_has_paid
    users = User.has_paid( events(:event1).id )
    assert_equal( 2, users.size )
    assert( users.include?( users(:user1 ) ) )
    assert( users.include?( users(:user_everything_paid ) ) )
  end
end

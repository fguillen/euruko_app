require File.dirname(__FILE__) + '/../test_helper'

class LoggedExceptionTest < ActiveSupport::TestCase

  def test_email_notification_when_an_exception_is_throwed
    ActionMailer::Base.deliveries = []
    
    logged_exception = 
      LoggedException.create!(
        :exception_class => Faker::Name.name,
        :controller_name => Faker::Name.name,
        :action_name     => Faker::Name.name,
        :request         => Faker::Name.name,
        :message         => Faker::Lorem.sentence,
        :backtrace       => Faker::Lorem.sentence
      )

    assert( logged_exception.valid? )
    assert !ActionMailer::Base.deliveries.empty?
    # sent = ActionMailer::Base.deliveries.last
    # 
    # puts sent    
  end
  
end
class UserMailer < ActionMailer::Base

  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
    @bcc         = APP_CONFIG[:email_notification_recipients]
    @body[:url]  = "http://#{APP_CONFIG[:site_domain]}/activate/#{user.activation_code}"
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://#{APP_CONFIG[:site_domain]}/"
  end

  def forgotten_password(user)
    setup_email(user)
    @subject    += 'Forgotten password'
  end

  def reset_password(user)
    setup_email(user)
    @subject    += 'Your password has been changed'
  end

  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "#{APP_CONFIG[:email_sender]}"
      @subject     = "[#{APP_CONFIG[:site_name]}] "
      @sent_on     = Time.now
      @body[:user] = user
    end
end

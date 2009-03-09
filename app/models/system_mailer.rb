class SystemMailer < ActionMailer::Base
  
  def exception( exception )
    setup
    @recipients  = APP_CONFIG[:email_notification_recipients]
    @subject    += "Exception: #{exception.exception_class}: #{exception.message}"
    @body[:url]  = "http://#{APP_CONFIG[:site_domain]}/"
    @body[:exception] = exception
  end

  def paper( paper )
    setup
    @recipients    = APP_CONFIG[:email_notification_recipients]
    @subject      += "Paper submitted to #{paper.family}: #{paper.title}"
    @body[:paper]  = paper
  end
  
  def cart_purchased_ok_to_user( cart )
    setup
    @recipients   = cart.user.email
    @subject     += "Payment received!"
    @body[:cart]  = cart
  end
  
  def cart_purchased_ok_to_admin( cart )
    setup
    @recipients   = APP_CONFIG[:email_notification_recipients]
    @subject     += "New purchase, id: #{cart.id}"
    @body[:cart]  = cart
  end
  
  def cart_purchased_error_to_user( cart )
    setup
    @recipients   = cart.user.email
    @subject     += "Some errors found at the purchase!"
    @body[:cart]  = cart
  end
  
  def cart_purchased_error_to_admin( cart )
    setup
    @recipients   = APP_CONFIG[:email_notification_recipients]
    @subject     += "Some errors found at the purchase, id: #{cart.id}"
    @body[:cart]  = cart
  end
  
  
  
  
  
  protected
  
    def setup
      @from        = "#{APP_CONFIG[:email_sender]}"
      @subject     = "[#{APP_CONFIG[:site_name]}] "
      @sent_on     = Time.now
    end
end

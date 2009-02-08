class SystemMailer < ActionMailer::Base
  
  def exception(email, exception)
    setup
    @recipients = email
    @subject    += "Exception: #{exception.exception_class}: #{exception.message}"
    @body[:url]  = "http://#{APP_CONFIG[:site_url]}/"
    @body[:exception] = exception
  end

  def paper(email, paper)
    setup
    @recipients = email
    @subject    += "Paper submitted to #{paper.family}: #{paper.title}"
    @body[:paper]  = paper
  end
  
  protected
  
    def setup
      @from        = "#{APP_CONFIG[:email_sender]}"
      @subject     = "[#{APP_CONFIG[:site_name]}] "
      @sent_on     = Time.now
    end
end

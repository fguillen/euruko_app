# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # restful_authentication
  include AuthenticatedSystem
  
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'aa97b2b8739be1577cff43d58dadd211'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  layout 'application'
  
  private
    def load_paper_by_paper_id
      @paper = Paper.find_by_id( params[:paper_id] )
    end
    
    def load_paper_by_id
      @paper = Paper.find_by_id( params[:id] )
    end
end

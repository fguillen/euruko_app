ActionController::Routing::Routes.draw do |map|

  map.root :controller => 'papers'
  
  # fguillen 2009-01-15: exception_notification
  map.connect "logged_exceptions/:action/:id", :controller => "logged_exceptions"
  
  # restful_authentication
  map.activate  '/activate/:activation_code', :controller => 'users',     :action => 'activate', :activation_code => nil 
  map.logout    '/logout',                    :controller => 'sessions',  :action => 'destroy'
  map.login     '/login',                     :controller => 'sessions',  :action => 'new'
  map.register  '/register',                  :controller => 'users',     :action => 'create'
  map.signup    '/signup',                    :controller => 'users',     :action => 'new'  
  
  # shopping cart
  
  map.resources :users do |users|
    map.resources :payments
  end
  
  map.resources :papers do |paper|
    paper.resources :comments
    paper.resources :speakers
    paper.resources :votes
    paper.resources :attendees
    paper.resources :resources    
  end
  map.resources :papers, :member => { :update_status => :put }
  
  map.resource :calendar
  map.resource :shopping_cart, :member => { :confirm => :post, :complete => :get }
  
  map.resource :session
  map.resources :rooms  
  map.resources :events
  map.resources :payment_notifications

  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

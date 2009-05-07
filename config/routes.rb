ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'papers'

  # fguillen 2009-01-15: exception_notification
  map.connect "logged_exceptions/:action/:id", :controller => "logged_exceptions"

  # restful_authentication
  map.activate          '/activate/:activation_code', :controller => 'users',     :action => 'activate', :activation_code => nil 
  map.logout            '/logout',                    :controller => 'sessions',  :action => 'destroy'
  map.login             '/login',                     :controller => 'sessions',  :action => 'new'
  map.register          '/register',                  :controller => 'users',     :action => 'create'
  map.signup            '/signup',                    :controller => 'users',     :action => 'new'
  map.forgot_password   '/forgot_password',           :controller => 'users',     :action => 'forgot_password'  
  map.reset_password    '/reset_password/:id',        :controller => 'users',     :action => 'reset_password'  

  # shopping cart
  # map.current_cart 'cart', :controller => 'carts', :action => 'show', :id => 'current'

  map.resources :users, :as => 'people' do |users|
    map.resources :payments
  end

  map.resources :papers, :as => 'talks' do |paper|
    paper.resources :comments
    paper.resources :speakers
    paper.resources :votes
    paper.resources :attendees
    paper.resources :resources
    paper.resource :photo
  end
  map.resources :papers, :member => { :update_status => :put }

  map.resources :rooms
  map.resources :events
  map.resource :calendar
  
  map.resources :carts, 
                :as => 'pay', 
                :member => { 
                  :confirm    => :post, 
                  :complete   => :get, 
                  :notificate => :post
                }
                
  map.resource :session
  map.resources :invoices, :only => :create
  map.resources :location_searchs, :only => :create
  map.resource  :avaliable_places_counter, :only => :show
  map.resources :static_pages

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
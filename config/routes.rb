ActionController::Routing::Routes.draw do |map|

  map.root :controller => 'papers'
  
  # restful_authentication
  map.activate  '/activate/:activation_code', :controller => 'users',     :action => 'activate', :activation_code => nil 
  map.logout    '/logout',                    :controller => 'sessions',  :action => 'destroy'
  map.login     '/login',                     :controller => 'sessions',  :action => 'new'
  map.register  '/register',                  :controller => 'users',     :action => 'create'
  map.signup    '/signup',                    :controller => 'users',     :action => 'new'
  
  # especcial routes
  map.shoping_cart  '/shoping_cart',          :controller => 'shoping_cart',  :action => 'new'    
  map.user_searcher '/user_searcher',         :controller => 'user',          :action => 'search'
  map.calendar_conf '/calendar_conf',         :controller => 'calendar',      :action => 'config'
  
  
  map.resources :users do |users|
    map.resources :payments
  end
  
  map.resources :papers do |papers|
    papers.resources :comments
    papers.resources :speakers
    papers.resources :votes
    papers.resources :attends
    papers.resources :resources
  end
  
  map.resource :session
  map.resources :rooms  
  map.resources :events
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

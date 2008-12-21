ActionController::Routing::Routes.draw do |map|
  map.resources :resources

  # restful_authentication
  map.activate  '/activate/:activation_code', :controller => 'users',     :action => 'activate', :activation_code => nil 
  map.logout    '/logout',                    :controller => 'sessions',  :action => 'destroy'
  map.login     '/login',                     :controller => 'sessions',  :action => 'new'
  map.register  '/register',                  :controller => 'users',     :action => 'create'
  map.signup    '/signup',                    :controller => 'users',     :action => 'new'
  
  map.resources :users
  map.resource  :session
  map.resources :attends
  map.resources :votes
  map.resources :resources
  map.resources :comments
  map.resources :rooms
  map.resources :speakers
  map.resources :papers
  map.resources :events
  map.resources :payments

  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

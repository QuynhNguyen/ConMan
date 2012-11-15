
ConMan::Application.routes.draw do


  root :to => 'frontpage#index'

  match 'settings' => 'settings#index'
  post 'settings/get_fb_permission'
 
  
  get 'fb/index'
  get 'fb/get_fb_friend_list'
  get 'fb/get_fb_newsfeed'
  post 'fb/get_fb_permission'
  post 'fb/fb_login'
  post 'fb/fb_logout'
  post 'fb/update_fb_status'
  get 'fb/fb_wall'
  post 'fb/post_fb_wall'

  #get 'profiles/get_fb_friend_list'
  #get 'profiles/get_fb_newsfeed'
  #post 'profiles/get_fb_permission'
  #post 'profiles/fb_login'
  #post 'profiles/fb_logout'
  #post 'profiles/update_fb_status'
  #match 'profiles' => 'profiles#index'
  #get 'profiles/fb_wall'
  #post 'profiles/post_fb_wall'

  get 'twitter/index'
  post 'twitter/tweet'
  post 'twitter/twitter_login'
  get 'twitter/twitter_authorize'

  resources :searches
  resources :users
  resources :log_in
  resources :password_recovery
  resources :username_recovery
  resources :private_messages
  resources :frontpage
  resources :contact_us
  resources :about

  match 'profiles/:id' => 'profiles#index', :via => :get
  match 'profiles/:id/social' => 'fb#index', :via => :get
  match 'status' => 'statuses#index', :via => :get
  match 'status' => 'statuses#update', :via => :post
  match 'user/:user_id/status/:status_id' => 'statuses#delete', :via => :get
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end

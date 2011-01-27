Staff::Application.routes.draw do
  
  resources :departments do
    resources :users
  end
  
  resources :users do
    resources :articles
    resources :awards
  end
  
  namespace :admin do
    
    root to: "users#index"
    
    resources :users
    resources :departments
    resources :awards
  end
  
  root to: "users#index"
  
  match "/auth/:provider/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", :as => :signout
  match "/profile/:id" => "users#edit", :as => :profile
  match "/users/authenticate/:code" => "users#authenticate", as: :user_activation
  
  # Handle routing errors (THIS MUST BE AT THE END OF THE FILE)
  match '*a', :to => 'errors#render_404'
end
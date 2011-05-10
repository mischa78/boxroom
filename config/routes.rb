Boxroom::Application.routes.draw do
  get '/signin',  :to => 'sessions#new'
  delete '/signout', :to => 'sessions#destroy'

  # Resources
  resources :admins, :only => [:new, :create]
  resources :sessions, :only => [:new, :create, :destroy]
  resources :reset_password, :except => [:index, :show, :destroy]
  resources :users, :except => :show
  resources :groups, :except => :show
  resources :files, :except => [:index, :new, :create]

  resources :clipboard, :only => [:create, :destroy] do
    post 'copy', :on => :member
    post 'move', :on => :member
    put 'reset', :on => :member
  end

  # Update a collection of permissions
  resources :permissions, :only => :update_multiple do
    put :update_multiple, :on => :collection
  end

  # Nested resources
  resources :folders, :shallow => true, :except => [:new, :create] do
    resources :folders, :only => [:new, :create]
    resources :files, :only => [:new, :create]
  end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "folders#index"
end

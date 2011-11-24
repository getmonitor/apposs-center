
Apposs::Application.routes.draw do

  devise_for :users

  root :to => 'home#index'

  get "home/index"

  namespace :admin, :module => "admin" do
    root :to => 'home#index'
    resources :directive_groups
    resources :apps do
      put :update_app_user_role, :on => :member
    end
    resources :users
    resources :roles
    resources :machines
    resources :rooms
  end
  
  namespace :backend, :module => 'backend' do
    resources :apps do
      resources :acls
    end
  end

  resources :directive_groups

  resources :directive_templates

  resources :directive_templates do
    post :load_other, :on => :collection
    post :add_all, :on => :collection
  end

  resources :apps do
    resources :envs

    resources :operation_templates do
      member do
        get  :group_form
        post :group_execute
        post :execute
      end
    end
    resources :softwares
    resources :machines
    
    member do
      get :rooms
      get :operations
      get :old_operations
      get :reload_machines
    end
  end
  
  resources :directives do
    put :event, :on => :member
    get :body, :on => :member
  end
  
  resources :envs do
    get :upload_properties, :on => :collection
  end

  resources :machines do
    member do
      put :change_env
      put :reset
      put :pause
      put :interrupt
      put :clean_all
      get :directives
      get :old_directives
    end
  end
  
  resources :operation_templates
  
  resources :operations do
    put :event, :on => :member  
    resources :machines, :module => 'operation' do
      get :directives, :on => :member
    end
  end
  resources :softwares
  
  resources :directive_groups do
    get :items, :on => :member
  end
  
  match ':controller(/:action(/:id(.:format)))'
end

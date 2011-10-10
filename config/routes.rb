
Apposs::Application.routes.draw do

  devise_for :users

  root :to => 'home#index'

  get "home/index"

  namespace :admin, :module => "admin" do
    root :to => 'home#index'
    resources :directive_templates
    resources :directive_groups
    resources :apps do
      put :update_app_user_role, :on => :member
    end
    resources :users
    resources :roles
    resources :machines
    resources :rooms
  end

  resources :directive_groups

  resources :apps do
    resources :envs

    resources :machines do
      member do
        get :command_state
        put :reset
      end
    end
    resources :operation_templates do
      member do
        get  :group_form
        post :group_execute
        post :execute
      end
    end
    resources :softwares

    member do
      get :rooms
      get :operations
      get :old_operations
    end
  end
  
  resources :directives do
    put :event, :on => :member
  end
  
  resources :envs do
    get :upload_properties, :on => :collection
  end

  resources :machines do
    member do
      put :reset
      get :directives
    end
  end
  
  resources :operation_templates
  
  resources :operations do
    resources :machines, :module => 'operation' do
      get :directives, :on => :member
    end
    member do
      put :event
    end
  end
  resources :softwares
  
  resources :directive_groups do
    get :items, :on => :member
  end
  
  match ':controller(/:action(/:id(.:format)))'
end

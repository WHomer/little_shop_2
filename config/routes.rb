Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'

  # resources :items, only: [:index, :show]
  get '/items', to: 'items#index', as: :items
  get '/items/:id', to: 'items#show', as: :item

  get '/carts', to: 'carts#show'
  post '/carts', to: 'carts#add'
  patch '/carts', to: 'carts#update'
  delete '/carts', to: 'carts#clear'

  get '/register', to: 'users#new'
  post '/register', to: 'users#create'

  get '/login', to: 'sessions#new', as: :login
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#logout'

  get '/profile', to: 'default/users#show'
  get '/profile/edit', to: 'default/users#edit'
  patch '/profile/edit', to: 'default/users#update'
  scope module: :default, path: :profile do
    # resources :orders, only: [:create, :show, :index, :destroy, :edit, :update], as: :profile_orders
    get '/orders', to: 'orders#index', as: :profile_orders
    get '/orders/:id', to: 'orders#show', as: :profile_order
    get '/orders/:id/edit', to: 'orders#edit', as: :edit_profile_order
    patch '/orders/:id', to: 'orders#update'
    delete '/orders/:id', to: 'orders#destroy'
    post '/orders', to: 'orders#create', as: :new_profile_order

    resources :user_addresses, only: [:update, :edit, :new, :create, :destroy], as: :profile_addresses
  end


  get '/merchants', to: 'merchants#index'

  patch 'merchants/items/enable/:id', to: 'merchants/items#enable'
  patch 'merchants/items/disable/:id', to: 'merchants/items#disable'

  get '/dashboard', to: 'merchants/orders#index'
  scope module: 'merchants', path: 'dashboard', as: :dashboard do
    # resources :order_items, only: [:update]
    patch '/order_item/:id', to: 'order_items#update', as: :order_item
    # resources :orders, only: [:show]
    get '/order/:id', to: 'orders#show', as: :order
  end

  scope module: 'merchants', path: 'dashboard' do
    # resources :items, only: [:index, :new, :create, :edit, :update, :destroy]
    get '/items', to: 'items#index', as: :dashboard_items
    get '/items/new', to: 'items#new', as: :new_dashboard_item
    post '/items', to: 'items#create' 
    get '/items/:id/edit', to: 'items#edit', as: :edit_dashboard_item
    patch '/items/:id', to: 'items#update', as: :dashboard_item
    delete '/items/:id', to: 'items#destroy'
  end

  namespace :admin do
    # resources :users, only: [:index, :show]
    get '/users', to: 'users#index', as: :users
    get '/user/:id', to: 'users#show', as: :user

    get '/dashboard', to: 'users#dashboard'
    get '/merchants/:id', to: 'merchants#show', as: :merchant
    patch '/merchant/edit', to: 'merchants#edit'
    patch '/merchant/enable/:id', to: 'merchants#enable'
    patch '/merchant/disable/:id', to: 'merchants#disable'
    patch '/orders/:id', to: 'orders#update', as: :order
    # resources :orders, only: [:update]
  end
end

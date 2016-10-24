Rails.application.routes.draw do
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'

  resources :auth, only: :show
  resources :sessions, only: [:create, :destroy]
  resource :home, only: [:show]

  match '/privacy_policy', :to => 'pages#privacy_policy', via: [:get]

  root to: "home#show"

  match '/usergroups/search', :to => "usergroups#search", via: [:get, :post]

  resources :usergroups

  match '/preferences/create', :to => "preferences#create", via: [:get, :post]

  resources :preferences

  resources :invites

  match '/memberships/create', :to => "memberships#create", via: [:get, :post]

  resources :memberships

  resources :users, only: [:show, :edit]

end

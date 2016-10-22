Rails.application.routes.draw do
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  resources :users

  match '/privacy_policy', :to => 'pages#privacy_policy', via: [:get]

  root to: "home#show"

  resources :usergroups

  match '/preferences/create', :to => "preferences#create", via: [:get, :post]

  resources :preferences

  resources :invites

  match '/memberships/create', :to => "memberships#create", via: [:get, :post]

  resources :memberships

end

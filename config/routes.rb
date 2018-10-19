Rails.application.routes.draw do
  resources :memberships
  resources :beer_clubs
  resources :users
  resources :beers
  resources :breweries
  resources :styles
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  root 'breweries#index'
  
  get 'signup', to: 'users#new'
  get 'signin', to: 'sessions#new'
  get 'places', to: 'places#index'

  get 'beerlist', to: 'beers#list'
  get 'brewerylist', to: 'breweries#list'

  post 'places', to: 'places#search'

  delete 'signout', to: 'sessions#destroy'

  resources :ratings, only: [:index, :new, :create, :destroy]
  resources :places, only: [:index, :show]
  
  resources :breweries do
    post 'toggle_activity', on: :member
  end
  
  resources :users do
    post 'toggle_closed', on: :member
  end

  resources :memberships do
    post 'toggle_confirmed', on: :member
  end

  resource :session, only: [:index, :new, :create, :destroy]


end


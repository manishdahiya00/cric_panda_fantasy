Rails.application.routes.draw do
  resources :score_cards
  resources :user_contests
  resources :user_teams
  resources :contests
  resources :contest_categories
  resources :match_teams
  resources :players
  resources :teams
  #resources :users
  resources :matches
  resources :competitions
  root 'welcome#login'
  mount API::CashApp::Base => '/'

  get '/logout' => 'welcome#logout'
  get '/dashboard' => 'welcome#index'
  get '/invite/:referral_code' => 'welcome#invite'
  match '/login' => 'welcome#login', :via => [:get, :post]
end

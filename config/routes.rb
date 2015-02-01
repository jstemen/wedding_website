Rails.application.routes.draw do
  root to: 'pages#home'
  get '/invitations/search', to: 'invitations#search'
  resources :invitations
end

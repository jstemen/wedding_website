Rails.application.routes.draw do
  root to: 'pages#home'
  get '/invitations/search', to: 'invitations#search'
  resources :invitations
  resources :guests

  resources :invitation_groups
  get 'invitation_groups/show/:code/guests', to: 'invitation_groups#show'
  get 'invitation_groups/show/:code/events', to: 'invitation_groups#show_events'

end

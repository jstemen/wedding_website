Rails.application.routes.draw do
  root to: 'pages#home'
  get '/invitation_groups/search', to: 'invitation_groups#search'
  get '/invitation_groups/confirmation', to: 'invitation_groups#confirmation'
  resources :invitations
  resources :guests
  resources :invitation_groups
  get 'pages/non_indian_guide',                 to: 'pages#non_indian_guide',        as: 'non_indian_guide'
  get 'invitation_groups/show/:code/thank_you', to: 'invitation_groups#thank_you',   as: 'thank_you'
  get 'invitation_groups/show/:code/guests',    to: 'invitation_groups#show',        as: 'add_guests'
  get 'invitation_groups/show/:code/events',    to: 'invitation_groups#show_events', as: 'link_guests_to_events'

end

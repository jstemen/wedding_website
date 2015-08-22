Rails.application.routes.draw do
  get 'reminder_emails/send_email_reminders'

  devise_for :admins, :controllers => {:registrations => "admins/registrations"}
  root to: 'pages#home'
  get '/invitation_groups/search', to: 'invitation_groups#show_events'
  get '/invitation_groups/confirmation', to: 'invitation_groups#confirmation'
  resources :invitation_groups do
    resources :guests
    resources :invitations
  end
  get 'invitation_groups/:id/edit_invitations', to: 'invitation_groups#edit_invitations', as: 'edit_invitations'
  post 'invitation_groups/:id/edit_invitations', to: 'invitation_groups#update_invitations', as: 'update_invitations'
  get 'pages/non_indian_guide', to: 'pages#non_indian_guide', as: 'non_indian_guide'
  get 'pages/save_the_date', to: 'pages#save_the_date', as: 'save_the_date'
  get 'invitation_groups/show/:code/thank_you', to: 'invitation_groups#thank_you', as: 'thank_you'
  get 'invitation_groups/show/:code/guests', to: 'invitation_groups#show', as: 'add_guests'
  get 'invitation_groups/show/:code/events', to: 'invitation_groups#show_events', as: 'link_guests_to_events'
  get 'reminders', to: 'reminder_emails#send_email_reminders', as: 'send_reminder_emails'
end

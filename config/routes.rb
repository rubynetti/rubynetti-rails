Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :spid do
    resource :metadata, only: :show
    resources :session, only: [:new, :create]
  end
  root to: 'spid/session#new'
end

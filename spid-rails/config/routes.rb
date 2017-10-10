Spid::Rails::Engine.routes.draw do
  resource :metadata, only: :show
  resources :session, only: [:new, :create]
end

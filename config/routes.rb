Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :spid do
    resource :metadata, only: :show
    resource :sso, only: [:new, :create], controller: :single_sign_ons
    resource :slo, only: [:new, :create], controller: :single_logout_operations
  end
  resource :welcome, controller: :welcome
  root to: 'welcome#show'
end

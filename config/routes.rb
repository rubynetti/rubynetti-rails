Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :spid do
    resource :metadata
    resources :session
  end
  #get  'metadata', to: 'spid#metadata'
  #post 'print_response', to: 'spid#print_response'
  root to: 'spid/session#new'
end

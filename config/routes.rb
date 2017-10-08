Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :spid
  get 'metadata', to: 'spid#metadata'
  
  post 'print_response', to: 'spid#print_response'
  root to: 'spid#index'
end

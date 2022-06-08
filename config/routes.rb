Rails.application.routes.draw do
  resources :issues
  resources :users
  post '/auth/login', to: 'authentication#login'
end

Rails.application.routes.draw do
  resources :gamers

  get '/play', to: 'roulettes#playManual', as: 'play'
  get '/reset', to: 'roulettes#reset', as: 'reset'

  root 'roulettes#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

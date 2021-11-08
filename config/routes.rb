Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # construir rota para desviar: http://localhost:3000/users 'devise/sessions#new' to: "#{root}#users"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :pedidos, only: [:index, :new, :create]
end

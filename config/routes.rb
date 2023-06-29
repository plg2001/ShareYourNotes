Rails.application.routes.draw do
  resources :richiesta_admins
  ActiveAdmin.routes(self)
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_scope :user do
    get "signin", to: 'devise/sessions#new'
    delete "signout", to: "devise/sessions#destroy"
    get "signup", to: "devise/registrations#new"
  end
  
  

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root  'pages#home'
  get 'about' => 'pages#about'
  
  resources :richiesta_admins do
    post 'create_richiesta_admin', on: :collection
  end
  
  get "/auth/facebook/callback", to: "omniauth_callbacks#facebook"

  get '/notes/search', to: 'notes#search', as: 'search_notes'
  resources :notes

end



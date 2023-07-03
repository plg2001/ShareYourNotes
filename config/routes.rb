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

  get '/notes/search', to: 'notes#search', as: 'search'
  get 'notes/:id/download', to: 'notes#download_file', as: 'download_note'
  get 'my_notes' => 'notes#myNotes'
  delete '/notes/:id/delete', to: 'notes#delete', as: 'remove_note'
  resources :notes
  

  

  get '/favourite', to: 'notes#favourite', as: 'favourite'
  post '/add_favourite', to: 'notes#add_favourite', as: 'add_favourite'
  delete '/remove_favourite', to: 'notes#remove_favourite', as: 'remove_favourite'
 

  
  resources :users
 
  resources :notes, only: %i[index show update]

  get '/notes/:id', to: 'notes#show', as: 'favourite_note'
  get '/notes/:id', to: 'notes#show', as: 'personal_note'
end



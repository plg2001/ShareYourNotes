Rails.application.routes.draw do
  resources :richiesta_admins
  ActiveAdmin.routes(self)
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  
  devise_scope :user do
    get "signin", to: 'devise/sessions#new'
    delete "signout", to: "devise/sessions#destroy"
    get "signup", to: "devise/registrations#new"
  end
  
  get 'update_google_drive_refresh_token', to: 'omniauth_callbacks_controller#update_google_drive_refresh_token'
  get '/files', to: 'files#index',as: 'your_file'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root  'pages#home'
  get 'faq' => 'pages#faq'
  
  resources :richiesta_admins do
    post 'create_richiesta_admin', on: :collection
  end
  
  get "/auth/facebook/callback", to: "omniauth_callbacks#facebook"

  get '/notes/search', to: 'notes#search', as: 'search'
  get 'notes/:id/download', to: 'notes#download_file', as: 'download_note'
  get 'notes/:id/download_video', to: 'notes#video_download', as: 'video_download'
  get 'my_notes' => 'notes#myNotes'
  delete '/notes/:id/delete', to: 'notes#delete', as: 'remove_note'
  get '/notes/recenti', to: 'notes#recenti',as: 'recent'
  get 'notes/:id/download_on_my_gd', to: 'notes#download_on_my_gd', as: 'download_on_my_gd'
  
  resources :notes do
    resources :comments
  end

  resources :notes
  

  resources :notes do
    member do
      get 'edit'
    end
  end

  get '/favourite', to: 'notes#favourite', as: 'favourite'
  post '/add_favourite', to: 'notes#add_favourite', as: 'add_favourite'
  delete '/remove_favourite', to: 'notes#remove_favourite', as: 'remove_favourite'
  

  get '/users/search', to: 'users#search', as: 'user_search'
  get '/users/:id', to: 'users#show', as: 'user'
  
  resources :users
 
  resources :notes, only: %i[index show update]

  get '/notes/:id', to: 'notes#show', as: 'favourite_note'
  get '/notes/:id', to: 'notes#show', as: 'personal_note'
  get '/notes/:id', to: 'notes#show', as: 'suggested_note'
  get '/notes/:id', to: 'notes#show', as: 'best_note'
  get '/notes/:id', to: 'notes#show', as: 'note_show'


  post '/conversations/create_ajax', to: 'conversations#create_ajax'
  post '/tags/search', to: 'tags#search'
  post '/topics/search', to: 'topics#search'

  resources :conversations do
    resources :messages
   end

   get 'suggested', to: 'notes#suggested', as: :suggested
   patch '/update_rating/:id', to: 'notes#update_rating', as: 'update_rating'
   get 'best', to: 'notes#best', as: :best
   
end



Rails.application.routes.draw do
  root 'pages#home'
  get 'about' => 'pages#about'
  #resources :notes
  #root :to => redirect('/note')*/
end
Rails.application.routes.draw do
  root 'pages#home'
  get 'team' => 'pages#about'
  #resources :notes
  #root :to => redirect('/note')*/
end
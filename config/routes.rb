Rails.application.routes.draw do
  devise_for :users
  root 'pages#home'
  get 'about' => 'pages#about'
  get 'contact' => 'pages#contact'
  #resources :notes
  #root :to => redirect('/note')*/
end
Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  post 'users/register'
  post 'users/signin'
  delete 'users/signout'
  patch 'users/update'

  post 'publications/create'
  get 'publications/show/:id', to: 'publications#show'
  get 'publications', to: 'publications#get_all'
  delete 'publications/:id', to: 'publications#destroy'
  patch 'publications/:id', to: 'publications#update'
  get 'publications/my_publications'
end

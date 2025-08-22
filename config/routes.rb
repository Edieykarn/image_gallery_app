Rails.application.routes.draw do
  get "photos/show"
  get "photos/new"
  get "photos/create"
  get "photos/edit"
  get "photos/update"
  get "photos/destroy"
  get "galleries/index"
  get "galleries/show"
  get "galleries/new"
  get "galleries/create"
  get "galleries/edit"
  get "galleries/update"
  get "galleries/destroy"
  devise_for :users
  root 'galleries#index'

  resources :galleries do
    member do
      get :slideshow
    end
    
    resources :photos, except: [:index]
  end

  resources :photos, only: [:show] do
    member do
      get :full_size
    end
  end
end

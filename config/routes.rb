Rails.application.routes.draw do
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

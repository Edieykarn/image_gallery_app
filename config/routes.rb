Rails.application.routes.draw do
  # Devise routes for authentication
  devise_for :users

  # Galleries & photos
  resources :galleries do
     resources :photos,  except: [:index]
     get :slideshow, on: :member


    end



  # Root path → list of galleries
  root "galleries#index"
end

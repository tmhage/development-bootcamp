Rails.application.routes.draw do
  devise_for :users

  namespace :admin do
    resources :posts, except: [:show] do
      member do
        put :publish
        put :unpublish
      end
    end
  end

  resources :posts, only: [:index, :show]
  resources :sponsors, only: [:index, :new, :create]

  root to: "posts#index"
end

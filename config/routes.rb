Rails.application.routes.draw do
  devise_for :users

  namespace :admin do
    resources :posts do
      put :publish
      put :unpublish
    end
  end

  resources :posts, only: [:index, :show]

  root to: "posts#index"
end

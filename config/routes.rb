Rails.application.routes.draw do
  devise_for :users

  get '/schedule' => 'static_pages#schedule'
  get '/tickets' => 'static_pages#tickets'
  get '/about' => 'static_pages#about'

  namespace :admin do
    resources :posts, except: :show do
      member do
        put :publish
        put :unpublish
      end
    end
    resources :sponsors, except: :show
  end

  resources :posts, only: [:index, :show]
  resources :sponsors, only: [:index, :new, :create]

  root to: "posts#index"
end

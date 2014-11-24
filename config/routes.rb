Rails.application.routes.draw do
  devise_for :users, :skip => [:registrations]
  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    put 'users/:id' => 'devise/registrations#update', :as => 'user_registration'
  end

  root to: "static_pages#about"
  get '/program' => 'static_pages#program'
  get '/tickets' => 'static_pages#tickets'
  get '/team' => 'static_pages#team'

  resources :blog, controller: 'posts', only: [:index, :show]
  resources :sponsors, only: [:index, :new, :create]

  namespace :admin do
    resources :posts, except: :show do
      member do
        put :publish
        put :unpublish
      end
    end
    resources :sponsors, except: :show
  end
end

Rails.application.routes.draw do
  devise_for :users, :skip => [:registrations]
  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    put 'users/:id' => 'devise/registrations#update', :as => 'user_registration'
  end

  root to: "static_pages#home"

  get '/program' => 'programs#index'
  get '/program/level-1' => 'programs#level_one'
  get '/program/level-2' => 'programs#level_two'
  get '/program/level-3' => 'programs#level_three'
  get '/program/level-4' => 'programs#level_four'

  get '/tickets' => 'students#new'
  get '/team' => 'static_pages#team'
  get '/code-of-conduct' => 'static_pages#code_of_conduct'

  resources :blog, controller: 'posts', only: [:index, :show]
  resources :sponsors, only: [:index, :new, :create] do
    collection do
      get :plans
    end
  end

  resources :speakers, only: [:index, :new, :create]
  resources :students, only: :create

  get '/sitemap.:format' => 'application#sitemap', constraints: { format: :xml }

  namespace :admin do
    resources :posts, except: :show do
      member do
        put :publish
        put :unpublish
      end
    end
    resources :sponsors, except: :show
    resources :speakers, except: :show
    resources :students, except: :show
    resources :workshops
    resources :lessons
  end
end

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

  get '/tickets' => 'orders#new'
  get '/team' => 'static_pages#team'
  get '/contact' => 'static_pages#contact'
  get '/newsletter' => 'static_pages#newsletter'

  get '/code-of-conduct' => 'static_pages#code_of_conduct'
  get '/terms-and-conditions' => 'static_pages#terms_and_conditions'
  get '/cancellation-policy' => 'static_pages#cancellation_policy'

  get '/open-day' => 'static_pages#open_day'

  get '/students/:id/qr-code' => 'students#qr_code'
  get '/students/:id/check' => 'students#check_qr_code'

  resources :blog, controller: 'posts', only: [:index, :show]
  resources :pages, only: [:show]
  resources :sponsors, only: [:index, :new, :create] do
    member do
      get :thanks
    end

    collection do
      get :plans
    end
  end

  resources :speakers, only: [:index, :new, :create] do
    member do
      get :thanks
    end
  end

  resources :tickets, controller: 'orders', only: [:create, :show] do
    collection do
      post :webhook
    end

    member do
      get :thanks
      post :stripe_webhook
      patch :stripe_token
    end
  end

  get '/sitemap.:format' => 'application#sitemap', constraints: { format: :xml }

  namespace :admin do
    get '/' => 'orders#index'

    require 'sidekiq/web'
    authenticate :user do
      mount Sidekiq::Web, at: "/sidekiq"
    end

    resources :discount_codes
    resources :posts, except: :show do
      member do
        put :publish
        put :unpublish
      end
    end
    resources :pages, except: :show do
      member do
        put :publish
        put :unpublish
      end
    end
    resources :sponsors, except: :show
    resources :speakers, except: :show
    resources :students, except: :show
    resources :orders, except: :show do
      member do
        patch :manually_paid
        patch :paid_by_creditcard
        patch :send_invoice
      end
    end
    resources :users, :except => :show
  end
end

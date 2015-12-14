Rails.application.routes.draw do
  localized do
    devise_for :users, :skip => [:registrations]

    as :user do
      get 'users/edit' => 'devise/registrations#edit', :as => :edit_user_registration
      put 'users/:id' => 'devise/registrations#update', :as => :user_registration
    end

    root to: "static_pages#home"

    get '/courses' => 'programs#index', as: :courses
    get '/courses/beginner-bootcamp' => 'programs#level_one', as: :courses_beginner_bootcamp
    get '/courses/intermediate-bootcamp' => 'programs#level_two', as: :courses_intermediate_bootcamp
    get '/courses/advanced-bootcamp' => 'programs#level_three', as: :courses_advanced_bootcamp
    get '/courses/frontend-bootcamp' => 'programs#frontend_bootcamp', as: :courses_frontend_bootcamp

    get '/enroll' => 'orders#new', as: :enroll
    get '/order/:id' => 'orders#show', as: :order
    get '/team' => 'static_pages#team', as: :team
    get '/contact' => 'static_pages#contact', as: :contact
    get '/newsletter' => 'static_pages#newsletter', as: :newsletter

    get '/code-of-conduct' => 'pages#show', id: 'code-of-conduct', as: :code_of_conduct
    get '/terms-and-conditions' => 'pages#show', id: 'terms-conditions', as: :terms_and_conditions
    get '/cancellation-policy' => 'pages#show', id: 'cancellation-policy', as: :cancellation_policy
    get '/faq' => 'pages#show', id: 'faq', as: :faq

    get '/open-evening' => 'static_pages#open_evening', as: :open_evening

    get '/students/:id/qr-code' => 'students#qr_code'
    get '/students/:id/check' => 'students#check_qr_code'

    resources :scholarships, only: [:create] do
      collection do
        get :apply
        get :thanks
      end
    end

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

    resources :enroll, controller: 'orders', only: [:create, :show] do
      collection do
        post :webhook
      end

      member do
        get :thanks
        post :stripe_webhook
        patch :stripe_token
      end
    end

    get '/sitemap.:format' => 'application#sitemap', constraints: { format: :xml }, as: :sitemap
  end

  namespace :admin do
    get '/' => 'orders#index'

    require 'sidekiq/web'
    authenticate :user do
      mount Sidekiq::Web, at: "/sidekiq"
    end

    resources :reviews
    resources :scholarships
    resources :discount_codes
    resources :bootcamps do
      member do
        put :publish
        put :unpublish
      end
    end
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

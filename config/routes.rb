Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :auth, only: %i[create destroy]
      resources :users, only: [:create]
      resources :books
      resources :borrows do
        member do
          patch 'return_book', to: 'borrows#return_book'
        end
      end
      resources :dashboard, only: [:index]
    end
  end
end

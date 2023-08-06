require 'sidekiq/web'

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  mount Sidekiq::Web => '/sidekiq'

  defaults format: :json do
    namespace :api do
      namespace :v1 do
        # Authentication routes
        post 'login',  to: 'authentication#login'
        post 'logout', to: 'authentication#logout'
        # Authentication route
        post 'registration', to: 'registration#create'

        # Books routes
        resources :books, except: %i[new edit] do
          collection do
            get 'search', to: 'search#books'
          end
        end
      end
    end
  end
end

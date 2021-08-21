require 'sidekiq/web'

Rails.application.routes.draw do
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

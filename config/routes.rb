Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  post "/login", to: "auth#login" # User authentication (JWT login)

  resources :auth, only: [] do
    collection do
      post "login", to: "auth#login" # User authentication (JWT login)
      get "me", to: "auth#me" # Get current user
    end
  end

  resources :users do
    collection do
      get "following_sleep_records", to: "users#following_sleep_records"
      post "clock_in", to: "users#clock_in"
      post "clock_out", to: "users#clock_out"
      get "clocked_in_times", to: "users#clocked_in_times"
    end
    member do
      post "follow", to: "users#follow"
      delete "unfollow", to: "users#unfollow"
    end
  end

  # Defines the root path route ("/")
  # root "posts#index"
end

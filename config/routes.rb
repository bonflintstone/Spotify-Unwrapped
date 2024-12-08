Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root to: "files#index"
  resources :files, only: %i[index show]
end

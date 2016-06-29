Rails.application.routes.draw do
  namespace :api, defaults: {format: 'json'} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      devise_for :admins, format: :json,
        controllers: { registrations: 'api/v1/admins/registrations' }
      devise_for :users, format: :json,
        controllers: { registrations: 'api/v1/users/registrations' }
      resources :admins, only: :show
      resources :users, only: :show
      resources :dishes, only: [:index, :create, :show, :update, :destroy] do
        resources :reviews, only: [:index, :create, :show, :update, :destroy]
      end
    end
  end

  root to: "home#show"
end

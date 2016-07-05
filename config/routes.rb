Rails.application.routes.draw do
  devise_for :admins,
    controllers: { registrations: 'admins/registrations' }
  devise_for :users,
    controllers: { registrations: 'users/registrations' }
  namespace :api, defaults: {format: 'json'} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :admins, only: :show
      resources :users, only: :show
      resources :dishes, only: [:index, :create, :show, :update, :destroy] do
        resources :reviews, only: [:index, :create, :show, :update, :destroy]
      end
    end
  end

  resources :dishes, only: [:new, :show, :index, :edit] do
    resources :reviews, only: [:new, :show, :index, :edit]
  end

  root to: "home#show"
end

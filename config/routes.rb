Rails.application.routes.draw do
  namespace :api, defaults: {format: 'json'} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :dishes except: [:new, :edit] do
        resources :reviews, only: [:create, :index, :update, :destroy]
      end
    end
  end
end

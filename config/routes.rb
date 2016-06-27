Rails.application.routes.draw do
  namespace :api, defaults: {format: 'json'} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      devise_for :admins, format: :json,
        controllers: { registrations: 'api/v1/admins/registrations',
                       sessions: 'api/v1/sessions' }
      devise_for :users, format: :json,
        controllers: { registrations: 'api/v1/users/registrations',
                       sessions: 'api/v1/sessions' }
      resources :dishes, except: [:new, :edit] do
        resources :reviews, only: [:create, :index, :update, :destroy]
      end
    end
  end

  root to: "home#show"
end

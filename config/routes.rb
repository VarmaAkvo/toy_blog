Rails.application.routes.draw do
  namespace :settings do
    resource :user, only: [:edit, :update]
    resource :blog, only: [:edit, :update]
  end

  resources :articles, only: [:new, :create]
  scope path: '/blogs/:name', as: 'user' do
    resources :articles, except: [:new, :create]
  end

  devise_for :users
  root to: "home#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

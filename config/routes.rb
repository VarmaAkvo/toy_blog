Rails.application.routes.draw do
  resources :articles, only: [:new, :create]
  scope path: '/blogs/:name', as: 'user' do
    resources :articles, except: [:new, :create]
  end
  #get '/blogs/:name/articles/:id', to: "articles#show", as: 'user_article'
  devise_for :users
  root to: "home#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

Rails.application.routes.draw do
  namespace :notify do
    get 'activities', to: 'activities#index'
    get 'comments',    to: 'comments#index'
    get 'replies',    to: 'replies#index'
  end
  get    '/following',                to: 'relations#index',   as: 'following'
  post   '/users/:user_id/following', to: 'relations#create'
  delete '/users/:user_id/following', to: 'relations#destroy',  as: 'user_following'

  post '/comments/:comment_id/replies',  to: 'replies#create',  as: 'comment_replies'
  post '/articles/:article_id/comments', to: 'comments#create', as: 'article_comments'

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

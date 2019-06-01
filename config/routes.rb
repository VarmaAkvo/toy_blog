Rails.application.routes.draw do
  namespace :search do
    get 'users/tags/:tag',    to: 'user_tags#index',    as: 'user_tags'
    get 'articles/tags/:tag', to: 'article_tags#index', as: 'article_tags'
    get 'articles',    to: 'articles#index',     as: 'articles'
    get 'users',       to: 'users#index',        as: 'users'
  end

  namespace :notify do
    get 'activities', to: 'activities#index'
    get 'comments',    to: 'comments#index'
    get 'replies',    to: 'replies#index'
  end

  get    '/following',                to: 'relations#index',   as: 'following'
  post   '/users/:user_id/following', to: 'relations#create'
  delete '/users/:user_id/following', to: 'relations#destroy',  as: 'user_following'

  post '/comments/:comment_id/replies',  to: 'replies#create',  as: 'comment_replies'
  delete '/replies/:id', to: 'replies#destroy', as: 'reply'
  post '/articles/:article_id/comments', to: 'comments#create', as: 'article_comments'
  delete '/comments/:id', to: 'comments#destroy', as: 'comment'

  namespace :settings do
    resource :user, only: [:edit, :update]
    resource :blog, only: [:edit, :update]
  end

  resources :articles, only: [:new, :create]
  scope path: '/blogs/:name', as: 'user' do
    resources :articles, except: [:new, :create]
  end
  # 放在这里防止匹配/blogs/:name/articles
  get 'blogs/:name/:tag', to: 'search/blog_tag_search#index', as: 'blog_tag_search'

  resources :blog_punishments, except: :show

  devise_for :users
  root to: "home#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

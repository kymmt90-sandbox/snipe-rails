Rails.application.routes.draw do
  post 'user_token', to: 'user_token#create'
  resource :user, only: [:show]
  resources :users, except: [:index] do
    resources :snippets, shallow: true, except: [:create] do
      resources :comments, shallow: true
      resource :star, only: [:show, :destroy]
      put 'star', to: 'stars#create'
    end
  end
  resources :snippets, only: [:index, :create]
  get 'api-docs', to: 'apidocs#index'
  match '*path', to: 'application#not_found', via: :all
end

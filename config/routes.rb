Rails.application.routes.draw do
  post 'user_token' => 'user_token#create'
  resources :users, except: [:index] do
    resources :snippets, shallow: true do
      resources :comments, shallow: true
      resource :star, only: [:show, :destroy]
      put 'star', to: 'stars#create'
    end
  end
  resources :snippets, only: [:index]
end

Rails.application.routes.draw do
  resources :users, except: [:index] do
    resources :snippets, shallow: true
  end
  resources :snippets, only: [:index]
end

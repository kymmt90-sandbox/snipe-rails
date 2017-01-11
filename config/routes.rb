Rails.application.routes.draw do
  resources :users, except: [:index] do
    resources :snippets, shallow: true do
      resources :comments, shallow: true
    end
  end
  resources :snippets, only: [:index]
end

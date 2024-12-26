Rails.application.routes.draw do
  devise_for :users, skip: [:registrations], controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    sessions: 'users/sessions'
  }

  authenticated :user do
    root to: "posts#index", as: :authenticated_root
  end

  devise_scope :user do
    unauthenticated :user do
      root to: "devise/sessions#new", as: :unauthenticated_root
    end
  end

  resources :posts, param: :slug do
    resources :comments, only: [:create, :edit, :update, :destroy]
    member do
      patch :approve
      patch :disapprove
      patch :set_score
    end
  end

  namespace :admin do
    resources :users, only: [:index, :new, :create, :edit, :update, :destroy]
  end

  resources :users, only: [:index]

  devise_scope :user do
    get 'login', to: 'devise/sessions#new'
    post 'login', to: 'devise/sessions#create'
    delete 'logout', to: 'devise/sessions#destroy'
  end

  resources :grades, only: [:index]
  resources :likes, only: [:create, :destroy]

  get '/users', to: 'admin/users#index'
  get 'pages/media'
  get 'pages/tos'
  get 'posts/:id/download', to: 'posts#download', as: 'download_post'
end

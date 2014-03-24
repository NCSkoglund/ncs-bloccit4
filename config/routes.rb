Bloccit4::Application.routes.draw do
 
  get "comments/create"
  devise_for :users

  resources :users, only: [:update]

  resources :topics do
    resources :posts, except: [:index] do
      resources :comments, only: [:create, :destroy]
      match '/up-vote', to: 'votes#up_vote', as: :up_vote, via: :get
      match '/down-vote', to: 'votes#down_vote', as: :down_vote, via: :get
    end
  end

  match "about", to: 'welcome#about', via: :get
  
  root to: 'welcome#index'
end

Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  root to: "questions#index"
  get 'attachments/destroy'

  namespace :api do
    namespace :v1 do
      resources :profiles do
        get :me, on: :collection
      end
      resources :questions, shallow: true do
        resources :answers
      end
    end
  end

  concern :likable do
    member do
      post :rate_up
      post :rate_down
      delete :rate_revoke
    end
  end

  resources :users do
    member do
      get :set_email
      patch :confirm_email
    end
  end

  concern :commentable do
    resources :comments, shallow: true
  end

  resources :questions, concerns: [:likable, :commentable] do
    resources :answers,concerns: [:likable, :commentable], shallow: true do
      patch :set_best, on: :member
    end
  end

  resources :attachments, only: :destroy

  mount ActionCable.server => '/cable'
end

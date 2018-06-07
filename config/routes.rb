Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"
  get 'attachments/destroy'

  concern :likable do
    member do
      post :rate_up
      post :rate_down
      delete :rate_revoke
    end
  end

  resources :questions, concerns: [:likable] do
    resources :answers,concerns: [:likable], shallow: true do
      patch :set_best, on: :member
    end
  end

  resources :attachments
end

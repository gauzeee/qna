Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"
  get 'attachments/destroy'

  resources :questions do
    resources :answers, shallow: true do
      patch :set_best, on: :member
    end
  end
  resources :attachments
end

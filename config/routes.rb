Rails.application.routes.draw do
  get 'tests/index'
  devise_for :users, :path_prefix =>'auth'
  root 'home#index'

  scope '/admin' do
    resources :users
    resources :tests
  end

  namespace :api do
    namespace :v1 do
      resource :auth_manager, only: [:create, :destroy] , as: "auth" do
        post :refresh_token
      end

      resources :tests, only: [:index] do
        member do
          get :questions, to: 'tests#questions'
          post :submit, to: 'tests#take_test'
        end
      end

    end
  end


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

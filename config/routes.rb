Rails.application.routes.draw do
  get 'tests/index'
  devise_for :users, :path_prefix =>'auth'
  root 'home#index'

  scope '/admin' do
    resources :users
    resources :tests
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

Rails.application.routes.draw do
  devise_for :users, :path_prefix =>'auth'
  root 'home#index'

  scope '/admin' do
    resources :users
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

Rails.application.routes.draw do
  root to: 'pages#home'

  get "/cadastro" => "users#new", as: :sign_up
  get "/login" => "clearance/sessions#new", as: :sign_in
  delete "/logout" => "clearance/sessions#destroy", as: :sign_out
  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource :session, controller: "clearance/sessions", only: [:create]
  resources :users, only: [:create] do
    resource :password, controller: "clearance/passwords", only: [:create, :edit, :update]
  end
end

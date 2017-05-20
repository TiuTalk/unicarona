Rails.application.routes.draw do
  root to: 'pages#home'

  get "/cadastro" => "users#new", as: :sign_up
  get "/login" => "clearance/sessions#new", as: :sign_in
  delete "/logout" => "clearance/sessions#destroy", as: :sign_out
  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource :session, controller: "clearance/sessions", only: [:create]
  resources :users, only: [:create] do
    resource :password, controller: "clearance/passwords", only: [:create, :edit, :update]
    post :set_device_token, on: :collection
  end

  resources :routes, path: 'rotas' do
    match :search, path: 'busca', on: :collection, via: [:get, :post]
  end
  resources :rides, path: 'caronas', only: [:create]

  resources :phone_confirmations, path: 'telefone', only: [:new, :create] do
    post :confirm, on: :collection
    get :confirm, on: :collection
  end
end

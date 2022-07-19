Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  scope "(:locale)", locale: /en|vi/ do
    root "static_page#home"
    get "/home", to:"static_page#home"
    get "/help", to: "static_page#help"
    resources :users
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    get "/login", to: "session#new"
    post "/login", to: "session#create"
    get "/logout", to: "session#destroy"
    resources :account_activations, only: :edit
    resources :password_resets, only: [:new, :create, :edit, :update]
  end
end

Rails.application.routes.draw do
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
  end
end

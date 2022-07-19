Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_page#home"
    get "/home", to:"static_page#home"
    get "/help", to: "static_page#help"
    resources :users
  end
end

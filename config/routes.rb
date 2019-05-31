Rails.application.routes.draw do
  get "/login", to: "users#new"
  scope "(:locale)", locale: /en|vi/ do
    get "static_pages/home"
    get "/help", to: "static_pages#help"
    get "/about", to: "static_pages#about"
    get "/contact", to: "static_pages#contact"
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"

    root "static_pages#home"
    resources :users
  end
end

Rails.application.routes.draw do
  get "/login", to: "users#new"
  scope "(:locale)", locale: /en|vi/ do
    get "static_pages/home"
    get "/help", to: "static_pages#help"
    get "/about", to: "static_pages#about"
    get "/contact", to: "static_pages#contact"
    get "/signup", to: "static_pages#signup"

    root "static_pages#home"
  end
end

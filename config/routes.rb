Rails.application.routes.draw do
  resources :invoices
  resources :clients


  # do
  #   resources :invoices
  # end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end

Rails.application.routes.draw do
  resources :chromosomes
  resources :alleles

  resources :generations

  root 'chromosomes#index'
end

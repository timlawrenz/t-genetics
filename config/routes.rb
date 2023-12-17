Rails.application.routes.draw do
  resources :chromosomes
  resources :alleles

  root 'chromosomes#index'
end

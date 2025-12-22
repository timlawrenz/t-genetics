Rails.application.routes.draw do
  resources :chromosomes do
    resources :generations do
      member do
        post 'procreate'
      end
      resources :organisms
    end
  end
  resources :alleles

  root 'chromosomes#index'
end

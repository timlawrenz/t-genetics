Rails.application.routes.draw do
  if Rails.env.development? || Rails.env.test?
    mount Rswag::Ui::Engine => '/api-docs'
    mount Rswag::Api::Engine => '/api-docs'
  end

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

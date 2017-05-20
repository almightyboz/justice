Rails.application.routes.draw do
  comfy_route :cms_admin, :path => '/admin'

  resources :terms
  resources :lessons

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "home#index"
  # Make sure this routeset is defined last
  comfy_route :cms, :path => '/', :sitemap => false
end

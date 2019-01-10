Rails.application.routes.draw do
  get 'terms', to: 'terms#index', as: :terms
  get 'privacy', to: 'privacies#index', as: :privacy
  root to: 'posts#new'
  get 'bookshelves', to: 'posts#index', as: :bookshelves
  # post 'search', to: 'posts#search'
  post 'make', to: 'posts#make'
end

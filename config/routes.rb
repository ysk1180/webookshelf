Rails.application.routes.draw do
  root to: 'posts#new'
  get 'posts/show'
  # post 'search', to: 'posts#search'
end

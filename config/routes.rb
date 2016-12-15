Rails.application.routes.draw do

  resources :accesses
  resources :tables, shallow: true do
    resources :coordinates, except: :index
    resources :cells, except: :index
    resources :records
  end

  devise_for :users

  scope "/admin" do
    resources :users
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'tables#index'

end

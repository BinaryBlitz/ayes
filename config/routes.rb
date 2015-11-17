Rails.application.routes.draw do
  root 'admin/questions#unpublished'
  devise_for :admins, path: 'admin', skip: :registrations

  namespace :admin do
    get 'settings' => 'settings#index'

    resources :questions do
      patch 'up', 'down', 'publish', on: :member
      get 'scheduled', 'published', 'unpublished', on: :collection
    end

    resources :tags, except: [:show]
    resources :exports, only: [:index] do
      get 'questions', 'answers', 'tags', on: :collection
    end
    resources :merge_groups
  end

  resources :questions, only: [:index] do
    resources :answers, only: [:create], shallow: true do
      collection do
        get 'similar'
        post 'forms' => 'forms#index'
      end
    end
  end
  resources :favorites, only: [:index, :create]
  resource :user, except: [:index, :new, :edit]

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end

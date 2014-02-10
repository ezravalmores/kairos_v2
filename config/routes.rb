Kairos::Application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
  
  root :to => "login#login"
  
  resources :person_tasks do
    collection do
      put 'submit_tasks'
    end
  end
    
  resources :people
  
  get "/" => "application#index", as: :application
  match 'login', to: 'login#login', as: :login ,via: [:get, :post]
  match 'set_date', to: 'login#set_date', as: :set_date , via: [:get, :post]
  match "submit_tasks" => "person_tasks#submit_tasks", :via => [:put]
  match "get_tasks_assignments" => 'tasks#get_tasks_assignments', :via => [:get]
  match "create_role_task" => 'tasks#create_role_task', :via => [:post]
  match "deactivate_role_task" => 'tasks#deactivate_role_task', :via => [:put]
  match "activate_role_task" => 'tasks#activate_role_task', :via => [:put]
  resources :tasks
  match "add_tasks_to_role" => "manage#add_tasks_to_role", :via => [:get, :post]
  
  get 'logout', to: 'login#logout', as: :logout
end

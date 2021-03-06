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
  
  #root :to => "login#login"
  
  match "/" => "application#index", :as => :application, via: [:get,:post]
  
  resources :activities
  match 'calendar', to: 'activities#calendar', as: :calendar, via: [:get, :post]
  
  resources :leaves
  match "submit_leaves" => "leaves#submit_leaves", :via => [:put]
  match "cancel_leave" => 'leaves#cancel_leave', :via => [:put]
  
  resources :person_tasks do
    collection do
      put 'submit_tasks'
    end
  end
    
  resources :people
  resources :rights
  resources :events
  
  match "submit_events" => "events#submit_events", :via => [:put]
  match "remove_person" => 'events#remove_person', :via => [:put]
  match "add_people" => 'events#add_people', :via => [:put]
  
  #get "/" => "application#index", as: :application, via: [:get,:post]
  match 'login', to: 'login#login', as: :login ,via: [:get, :post]
  match 'logout', to: 'login#logout', as: :logout, via: [:get, :post]
  match 'dashboard', to: 'person_tasks#dashboard', as: :dashboard, via: [:get, :post]
  match "has_seen" => 'activities#has_seen', :via => [:put]
  
  match 'set_date', to: 'login#set_date', as: :set_date , via: [:get, :post]
  match "submit_tasks" => "person_tasks#submit_tasks", :via => [:put]
  match "get_tasks_assignments" => 'tasks#get_tasks_assignments', :via => [:get]
  match "create_role_task" => 'tasks#create_role_task', :via => [:post]
  match "deactivate_role_task" => 'tasks#deactivate_role_task', :via => [:put]
  match "activate_role_task" => 'tasks#activate_role_task', :via => [:put]
  
  resources :tasks
  
  match "tasks_report" => 'reports#tasks_report', :via => [:get,:post]
  match "utilization_rates" => 'reports#utilization_rates', :via => [:get,:post]
  match "search_tasks" => 'reports#search_tasks', :via => [:get,:post]
  match "search_rates" => 'reports#search_rates', :via => [:get,:post]
  
  match "add_tasks_to_role" => "manage#add_tasks_to_role", :via => [:get, :post]
  match "get_specific_tasks_assignments" => 'specific_tasks#get_specific_tasks_assignments', :via => [:get]
  match "get_role_task" => 'specific_tasks#get_role_task', :via => [:get]
  match "create_specific_role_task" => 'specific_tasks#create_specific_role_task', :via => [:post]
  
  resources :specific_tasks
  match "deactivate_role_specific_task" => 'specific_tasks#deactivate_role_specific_task', :via => [:put]
  match "activate_role_specific_task" => 'specific_tasks#activate_role_specific_task', :via => [:put]
  
  match "tasks_approval" => 'approvals#tasks_approval', :via => [:get,:post]
  match "leaves_approval" => 'approvals#leaves_approval', :via => [:get,:post]
  
  match "approve_tasks" => 'approvals#approve_tasks', :via => [:put]
  match "disapprove_tasks" => 'approvals#disapprove_tasks', :via => [:put]
  
  match "approve_leaves" => 'approvals#approve_leaves', :via => [:put]
  match "disapprove_leaves" => 'approvals#disapprove_leaves', :via => [:put]
  
  match "end_task" => 'person_tasks#end_task', :via => [:put]
  match "generate_spreadsheets" => "reports#generate_spreadsheets", :as => :generate_spreadsheets, :via => [:get, :post]
  
end

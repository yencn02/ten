Ten::Application.routes.draw do
  resources :billable_time
  match "logout", :to => "sessions#destroy", :as => "logout"
  match "login", :to => "sessions#new", :as => "login"
  match "/register", :to => "accounts#create", :as => :register
  match "/signup", :to => "accounts#new", :as => :signup

  resources :accounts do
    collection do
      get :client
      get :paginate_clients
      get :paginate_workers
      get :worker
    end       
  end
  
  resources :invoices do    
    collection do
      get :list
    end
  end
  
  resources :messages do    
    collection do 
      get :list
      get :read_message
    end
  end

  resources :milestones do
    collection do
     get :list
    end
  end

  resources :projects do
    collection do
      get :paginate
      get :active
      get :inactive
    end    
  end
  
  resources :tasks do 
    collection do
      get :show_estimate
      put :estimate
      put :volunteer
      get :list
      get :new_task
      get :paginate_notes
      get :assign_task
      get :save_message_client
      get :delete_message_client
    end    
  end


  resources :timesheets do
    collection do
      get :projects
      get :workers
    end   
  end

  resources :views do 
    collection do
      get :projects_list
      get :projects_new
      get :tasks_list
      get :tasks_show
    end
  end
    

  namespace :client do    
    resources :messages do
      collection do
        get :list
        put :update_status
      end
    end
    resources :requests do
      collection do
        get :list
        get :paginate_changes
        put :update_state_and_priority           
      end      
    end
    resources :projects do
      collection do
        get :paginate
      end
      resources :requests
    end   
  end

  resources :client_requests do
    collection do
      get :list
      put :update_state_and_priority
    end
  end
  resource :session

  match "admin", :to => "admin/companies#index"
  namespace :admin do 
    resources :workers
    resources :clients
    resources :companies
    resources :client_companies
    resources :worker_groups
    resources :client_groups
  end


  match "tasks/assign_task/:id" => "tasks#assign_task", :as => "assign_task"
  match "tasks/show_estimate/:id" => "tasks#show_estimate", :as => "show_estimate_task"
  match "admin/client_companies/:id/confirm/:new_status", :to => "admin/client_companies#confirm_status"
  match "admin/client_companies/:id/set/:new_status", :to => "admin/client_companies#set_status"
  match "admin/companies/:id/confirm/:new_status", :to => "admin/companies#confirm_status"
  match "admin/companies/:id/set/:new_status", :to => "admin/companies#set_status"
  match "client/requests/project/:project_id/:priority", :to => "client/requests#index", :as => :list_requests_by_priority
  match "client/requests/project/:project_id", :to => "client/requests#index", :as => :list_requests_by_project
  match "client/requests/:id/project/:project_id/:priority", :to => "client/requests#show", :as => :show_client_request
  match "client/requests/new_change", :to => "client/requests#new_change", :as => :client_request_change

  match "client_requests/project/:project_id/:priority", :to => "client_requests#index", :as => :manager_list_requests_by_priority
  match "client_requests/project/:project_id", :to => "client_requests#index", :as => :manager_list_requests_by_project
  match "client_requests/new/:id", :to => "client_requests#new", :as => :client_request_new

  match "invoices/list/:client_id", :to => "invoices#list"

  match "messages/delete/:id/:idSuffix", :to => "messages#delete"
  match "messages/list/:status", :to => "messages#list"
  match "client/messages/list/:status", :to => "client/messages#list"
  match "client/messages/update_status", :to => "client/messages#update_status"
  match "milestones/list/:project_id", :controller => "milestones", :action => "list"


  match "tasks/project/:project_id/:status/page/:page", :to => "tasks#list"
  match "tasks/list/:project_id/:status", :to => "tasks#list"
  match "tasks/project/:project_id/page/:page", :to => "tasks#list"
  match "tasks/:status/page/:page", :to => "tasks#list"
  match "tasks/list/:status", :to => "tasks#list"
  match "tasks/list", :to => "tasks#list"
  match "tasks/assign_task/:id", :to => "tasks#assign_task"  
  match "project/:project_id/tasks/:id/status/:status", :to => "tasks#show"
  match "project/:project_id/tasks/:id", :to => "tasks#show"
  match "tasks/delete_message_dev/:id", :to => "tasks#delete_message_dev", :as => :delete_message_dev
  match "tasks/delete_message_client/:id", :to => "tasks#delete_message_client", :as => :delete_message_client


  match "timesheets/list/project/:project_id", :to => "timesheets#list_by_project"
  match "timesheets/list/worker/:worker_id", :to => "timesheets#list_by_worker"


  root :to => "home#index"
  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  # map.connect ':controller/service.wsdl', :action => 'wsdl'
  # Install the default route as the lowest priority.
  match ':controller(/:action(/:id(.:format)))'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end

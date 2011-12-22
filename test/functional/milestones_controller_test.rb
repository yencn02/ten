require File.dirname(__FILE__) + '/../functional_test_helper'
require 'milestones_controller'
include AuthenticatedTestHelper

# Re-raise errors caught by the controller.
class MilestonesController; def rescue_action(e) raise e end; end

class MilestonesControllerTest < Test::Unit::TestCase
  fixtures :milestones, :projects, :users, :roles, :roles_users
  
  def setup
    @controller = MilestonesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as('default')
  end
  
  def test_access_client    
     
    #client    
    login_as('client')     
        
    msg = "Client don't have privileges to access invoice_system/"
    
    #list
    get :list
    assert_response :success
    assert_template 'error' , msg + "list"  
    
    #show
    get :show
    assert_response :success
    assert_template 'error' , msg + "show"  
    
    #new
    get :new
    assert_response :success
    assert_template 'error' , msg + "new"  
    
    #create
    get :create
    assert_response :success
    assert_template 'error' , msg + "create"  
    
    #update
    get :update
    assert_response :success
    assert_template 'error' , msg + "update"  
    
    #update_client_requests
    get :update_client_requests
    assert_response :success
    assert_template 'error' , msg + "update_client_requests"  
    
    #delete
    get :delete
    assert_response :success
    assert_template 'error' , msg + "delete"  
    
    #update_done_approved
    get :update_done_approved
    assert_response :success
    assert_template 'error' , msg + "update_done_approved"  
    
    #list_client_requests
    get :list_client_requests
    assert_response :success
    assert_template 'error' , msg + "list_client_requests"  
                
    logout()                  
  end
  
#  def test_access_sale    
#     
#    #client    
#    login_as('sales')     
#        
#    msg = "Sales don't have privileges to access invoice_system/"
#    
#    #list
#    get :list
#    assert_response :success
#    assert_template 'error' , msg + "list"  
#    
#    #show
#    get :show
#    assert_response :success
#    assert_template 'error' , msg + "show"  
#    
#    #new
#    get :new
#    assert_response :success
#    assert_template 'error' , msg + "new"  
#    
#    #create
#    get :create
#    assert_response :success
#    assert_template 'error' , msg + "create"  
#    
#    #update
#    get :update
#    assert_response :success
#    assert_template 'error' , msg + "update"  
#    
#    #update_client_requests
#    get :update_client_requests
#    assert_response :success
#    assert_template 'error' , msg + "update_client_requests"  
#    
#    #delete
#    get :delete
#    assert_response :success
#    assert_template 'error' , msg + "delete"  
#    
#    #update_done_approved
#    get :update_done_approved
#    assert_response :success
#    assert_template 'error' , msg + "update_done_approved"  
#    
#    #list_client_requests
#    get :list_client_requests
#    assert_response :success
#    assert_template 'error' , msg + "list_client_requests"  
#                
#    logout()                  
#  end
  
#  def test_access_handler    
#     
#    #client    
#    login_as('handler')     
#        
#    msg = "Handler don't have privileges to access invoice_system/"
#           
#    #delete
#    get :delete
#    assert_response :success
#    assert_template 'error' , msg + "delete"  
#                    
#    logout()                  
#  end
  
  def test_access_worker    
     
    #client    
    login_as('worker')     
        
    msg = "Worker don't have privileges to access invoice_system/"
    
    #list
    get :list
    assert_response :success
    assert_template 'error' , msg + "list"  
    
    #show
    get :show
    assert_response :success
    assert_template 'error' , msg + "show"  
    
    #new
    get :new
    assert_response :success
    assert_template 'error' , msg + "new"  
    
    #create
    get :create
    assert_response :success
    assert_template 'error' , msg + "create"  
    
    #update
    get :update
    assert_response :success
    assert_template 'error' , msg + "update"  
    
    #update_client_requests
    get :update_client_requests
    assert_response :success
    assert_template 'error' , msg + "update_client_requests"  
    
    #delete
    get :delete
    assert_response :success
    assert_template 'error' , msg + "delete"  
    
    #update_done_approved
    get :update_done_approved
    assert_response :success
    assert_template 'error' , msg + "update_done_approved"  
    
    #list_client_requests
    get :list_client_requests
    assert_response :success
    assert_template 'error' , msg + "list_client_requests"  
                
    logout()                  
  end
  
#  def test_access_payables    
#     
#    #client    
#    login_as('payables')     
#        
#    msg = "Payables don't have privileges to access invoice_system/"
#    
#    #list
#    get :list
#    assert_response :success
#    assert_template 'error' , msg + "list"  
#    
#    #show
#    get :show
#    assert_response :success
#    assert_template 'error' , msg + "show"  
#    
#    #new
#    get :new
#    assert_response :success
#    assert_template 'error' , msg + "new"  
#    
#    #create
#    get :create
#    assert_response :success
#    assert_template 'error' , msg + "create"  
#    
#    #update
#    get :update
#    assert_response :success
#    assert_template 'error' , msg + "update"  
#    
#    #update_client_requests
#    get :update_client_requests
#    assert_response :success
#    assert_template 'error' , msg + "update_client_requests"  
#    
#    #delete
#    get :delete
#    assert_response :success
#    assert_template 'error' , msg + "delete"  
#    
#    #update_done_approved
#    get :update_done_approved
#    assert_response :success
#    assert_template 'error' , msg + "update_done_approved"  
#    
#    #list_client_requests
#    get :list_client_requests
#    assert_response :success
#    assert_template 'error' , msg + "list_client_requests"  
#                
#    logout()                  
#  end
  
  def test_access_lead    
     
    #client    
    login_as('lead')     
        
    msg = "Lead don't have privileges to access invoice_system/"
           
    #delete
    get :delete
    assert_response :success
    assert_template 'error' , msg + "delete"  
                    
    logout()                  
  end
  
#  def test_access_clientservice    
#     
#    #client    
#    login_as('clientservice')     
#        
#    msg = "Clientservice don't have privileges to access invoice_system/"
#           
#    #delete
#    get :delete
#    assert_response :success
#    assert_template 'error' , msg + "delete"  
#                    
#    logout()                  
#  end
  
  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end
  
  def test_list
    get :list
    assert_response :success
    assert_template 'list'
    
#    assert_not_nil assigns(:milestones)
  end

  def test_list_milestone
    get :list_milestone
    assert_redirected_to :action => 'list'    
  end
  
  def test_list_milestone_with_params
    # sort by name
    get :list_milestone, :sort => 'name'
    assert_redirected_to :action => 'list'  
    
    # sort by due_date
    get :list_milestone, :sort => 'due_date'
    assert_redirected_to :action => 'list'  
    
    # sort by done_approved
    get :list_milestone, :sort => 'done_approved'
    assert_redirected_to :action => 'list'  
    
    # sort by project_id
    get :list_milestone, :sort => 'project_id'
    assert_redirected_to :action => 'list'  
  end
  

  def test_show
    get :show, :id => 1
    
    assert_response :success
    assert_template 'show'
    
    assert_not_nil assigns(:milestone)
    assert_not_nil assigns(:client_requests)
    assert_not_nil assigns(:user)
    assert_not_nil assigns(:user_role_names)
    
    # invalid ID
    get :show, :id => '100'
    assert_response :redirect
    assert_not_nil flash[:notice]
    assert_redirected_to :controller => 'account', :action => "error"
    
    get :show, :id => 'id'
    assert_response :redirect
    assert_not_nil flash[:notice]
    assert_redirected_to :controller => 'account', :action => "error"
  end
  
  def test_new
    get :new
    assert_response :success
    assert_template 'new'
    
    assert_not_nil assigns(:milestone)
    assert_not_nil assigns(:projects)
    assert_not_nil assigns(:user)
    assert_not_nil assigns(:user_role_names)
  end
  
  def test_create
    # OK
    post :create, 
      {:milestone => {:name => "name", :project_id => 1, :due_date => '2007-12-13'}}
    assert_response :redirect
    assert_not_nil flash[:notice]
    assert_equal 'Milestone was successfully created.', flash[:notice]
    assert_redirected_to :action => 'list'
    
    # Error
    post :create, {:milestone => {:due_date => '2007-12-13'}}
    assert !assigns(:milestone).valid?
    assert_not_nil assigns(:milestone).errors.on(:name)
    assert_not_nil assigns(:milestone).errors.on(:project_id)
    assert_template 'new'
  end
  
  def test_edit
    post :edit, :id => 1
    assert_response :success
    assert_template 'edit'
    
    assert_not_nil assigns(:milestone)
    assert_not_nil assigns(:projects)
  end
  
  def test_update
    post :update, {:id => 1, :milestone => {:name => 'new name'}}
    assert_response :redirect
    assert_redirected_to :action => "show"
    
    post :update, {:id => 100, :milestone => {:name => 'new name'}}
    assert_not_nil assigns(:milestone)
    assert_not_nil assigns(:projects)
    assert_template 'edit'
  end
  
  def test_update_client_requests
    #post :update_client_requests, {}
  end
  
  def test_delete
    id = 1
    assert_nothing_raised {
      Milestone.find(id)
    }
    post :delete, :id => id
    assert_response :redirect
    assert_redirected_to :action => 'list'
    
    # not found
    assert_raise(ActiveRecord::RecordNotFound){
      Milestone.find(id)
    }
  end
  
  def test_update_done_approved
    post :update_done_approved, :set_done_approved => true
    assert_response :success
  end
  
  def test_private_compute_sort_string
    assert_raise(ActionController::UnknownAction){
      get :compute_sort_string
    }
  end
end

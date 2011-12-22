require File.dirname(__FILE__) + '/../functional_test_helper'
require 'client_requests_controller'
require 'client_request'
include AuthenticatedTestHelper

# Re-raise errors caught by the controller.
class ClientRequestsController; def rescue_action(e) raise e end; end

class ClientRequestsControllerTest < Test::Unit::TestCase
  fixtures :client_requests, :client_request_options, :client_request_changes, :projects, :users, :roles, :roles_users
  
  def setup
    @controller = ClientRequestsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as('default')
  end
  
#  def test_access_sales    
#     
#    #client    
#    login_as('sales')     
#        
#    msg = "Sales don't have privileges to access client_requests/"
#                
#    #index
#    get :index
#    assert_response :success
#    assert_template 'error' , msg + "index"  
#    
#    #list
#    get :list
#    assert_response :success
#    assert_template 'error' , msg + "list"  
#        
#    #list_all
#    get :list_all
#    assert_response :success
#    assert_template 'error' , msg + "list_all"  
#    
#    #list_all_tab
#    get :list_all_tab
#    assert_response :success
#    assert_template 'error' , msg + "list_all_tab"  
#    
#    #list_tab
#    get :list_tab
#    assert_response :success
#    assert_template 'error' , msg + "list_tab"  
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
#    #show
#    get :show
#    assert_response :success
#    assert_template 'error' , msg + "show"  
#    
#    #edit
#    get :edit
#    assert_response :success
#    assert_template 'error' , msg + "edit"  
#    
#    #update
#    get :update
#    assert_response :success
#    assert_template 'error' , msg + "update"  
#    
#    #delete
#    get :delete
#    assert_response :success
#    assert_template 'error' , msg + "delete"  
#    
#    #update_positions
#    get :update_positions
#    assert_response :success
#    assert_template 'error' , msg + "update_positions"  
#    
#    #done_and_approved
#    get :done_and_approved
#    assert_response :success
#    assert_template 'error' , msg + "done_and_approved"  
#    
#    #create_discussion
#    get :create_discussion
#    assert_response :success
#    assert_template 'error' , msg + "create_discussion"  
#    
#    #list_discussion
#    get :list_discussion
#    assert_response :success
#    assert_template 'error' , msg + "list_discussion"  
#    
#    #show_discussion
#    get :show_discussion
#    assert_response :success
#    assert_template 'error' , msg + "show_discussion"  
#    
#    #delete_discussion
#    get :delete_discussion
#    assert_response :success
#    assert_template 'error' , msg + "delete_discussion"  
#    
#    #list_thread
#    get :list_thread
#    assert_response :success
#    assert_template 'error' , msg + "list_thread"  
#    
#    #show_thread_form
#    get :show_thread_form
#    assert_response :success
#    assert_template 'error' , msg + "show_thread_form"  
#    
#    #create_thread
#    get :create_thread
#    assert_response :success
#    assert_template 'error' , msg + "create_thread"  
#    
#    #list_changed
#    get :list_changed
#    assert_response :success
#    assert_template 'error' , msg + "list_changed"  
#    
#    #show_changed
#    get :show_changed
#    assert_response :success
#    assert_template 'error' , msg + "show_changed"  
#    
#    #list_file
#    get :list_file
#    assert_response :success
#    assert_template 'error' , msg + "list_file"  
#    
#    #upload
#    get :upload
#    assert_response :success
#    assert_template 'error' , msg + "upload"  
#    
#    #upload_file
#    get :upload_file
#    assert_response :success
#    assert_template 'error' , msg + "upload_file"  
#    
#    #download
#    get :download
#    assert_response :success
#    assert_template 'error' , msg + "download"  
#            
#    logout()                  
#  end
  
#  def test_access_payables    
#     
#    #client    
#    login_as('payables')     
#        
#    msg = "Payables don't have privileges to access client_requests/"
#                
#    #index
#    get :index
#    assert_response :success
#    assert_template 'error' , msg + "index"  
#    
#    #list
#    get :list
#    assert_response :success
#    assert_template 'error' , msg + "list"  
#        
#    #list_all
#    get :list_all
#    assert_response :success
#    assert_template 'error' , msg + "list_all"  
#    
#    #list_all_tab
#    get :list_all_tab
#    assert_response :success
#    assert_template 'error' , msg + "list_all_tab"  
#    
#    #list_tab
#    get :list_tab
#    assert_response :success
#    assert_template 'error' , msg + "list_tab"  
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
#    #show
#    get :show
#    assert_response :success
#    assert_template 'error' , msg + "show"  
#    
#    #edit
#    get :edit
#    assert_response :success
#    assert_template 'error' , msg + "edit"  
#    
#    #update
#    get :update
#    assert_response :success
#    assert_template 'error' , msg + "update"  
#    
#    #delete
#    get :delete
#    assert_response :success
#    assert_template 'error' , msg + "delete"  
#    
#    #update_positions
#    get :update_positions
#    assert_response :success
#    assert_template 'error' , msg + "update_positions"  
#    
#    #done_and_approved
#    get :done_and_approved
#    assert_response :success
#    assert_template 'error' , msg + "done_and_approved"  
#    
#    #create_discussion
#    get :create_discussion
#    assert_response :success
#    assert_template 'error' , msg + "create_discussion"  
#    
#    #list_discussion
#    get :list_discussion
#    assert_response :success
#    assert_template 'error' , msg + "list_discussion"  
#    
#    #show_discussion
#    get :show_discussion
#    assert_response :success
#    assert_template 'error' , msg + "show_discussion"  
#    
#    #delete_discussion
#    get :delete_discussion
#    assert_response :success
#    assert_template 'error' , msg + "delete_discussion"  
#    
#    #list_thread
#    get :list_thread
#    assert_response :success
#    assert_template 'error' , msg + "list_thread"  
#    
#    #show_thread_form
#    get :show_thread_form
#    assert_response :success
#    assert_template 'error' , msg + "show_thread_form"  
#    
#    #create_thread
#    get :create_thread
#    assert_response :success
#    assert_template 'error' , msg + "create_thread"  
#    
#    #list_changed
#    get :list_changed
#    assert_response :success
#    assert_template 'error' , msg + "list_changed"  
#    
#    #show_changed
#    get :show_changed
#    assert_response :success
#    assert_template 'error' , msg + "show_changed"  
#    
#    #list_file
#    get :list_file
#    assert_response :success
#    assert_template 'error' , msg + "list_file"  
#    
#    #upload
#    get :upload
#    assert_response :success
#    assert_template 'error' , msg + "upload"  
#    
#    #upload_file
#    get :upload_file
#    assert_response :success
#    assert_template 'error' , msg + "upload_file"  
#    
#    #download
#    get :download
#    assert_response :success
#    assert_template 'error' , msg + "download"  
#            
#    logout()                  
#  end
  
#  def test_access_handler   
#     
#    #client    
#    login_as('handler')     
#        
#    msg = "Handler don't have privileges to access client_requests/"
#                
#    #index
#    get :index
#    assert_response :success
#    assert_template 'error' , msg + "index"  
#    
#    #list
#    get :list
#    assert_response :success
#    assert_template 'error' , msg + "list"  
#        
#    #list_all
#    get :list_all
#    assert_response :success
#    assert_template 'error' , msg + "list_all"  
#    
#    #list_all_tab
#    get :list_all_tab
#    assert_response :success
#    assert_template 'error' , msg + "list_all_tab"  
#    
#    #list_tab
#    get :list_tab
#    assert_response :success
#    assert_template 'error' , msg + "list_tab"  
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
#    #show
#    get :show
#    assert_response :success
#    assert_template 'error' , msg + "show"  
#    
#    #edit
#    get :edit
#    assert_response :success
#    assert_template 'error' , msg + "edit"  
#    
#    #update
#    get :update
#    assert_response :success
#    assert_template 'error' , msg + "update"  
#    
#    #delete
#    get :delete
#    assert_response :success
#    assert_template 'error' , msg + "delete"  
#    
#    #update_positions
#    get :update_positions
#    assert_response :success
#    assert_template 'error' , msg + "update_positions"  
#    
#    #done_and_approved
#    get :done_and_approved
#    assert_response :success
#    assert_template 'error' , msg + "done_and_approved"  
#    
#    #create_discussion
#    get :create_discussion
#    assert_response :success
#    assert_template 'error' , msg + "create_discussion"  
#    
#    #list_discussion
#    get :list_discussion
#    assert_response :success
#    assert_template 'error' , msg + "list_discussion"  
#    
#    #show_discussion
#    get :show_discussion
#    assert_response :success
#    assert_template 'error' , msg + "show_discussion"  
#    
#    #delete_discussion
#    get :delete_discussion
#    assert_response :success
#    assert_template 'error' , msg + "delete_discussion"  
#    
#    #list_thread
#    get :list_thread
#    assert_response :success
#    assert_template 'error' , msg + "list_thread"  
#    
#    #show_thread_form
#    get :show_thread_form
#    assert_response :success
#    assert_template 'error' , msg + "show_thread_form"  
#    
#    #create_thread
#    get :create_thread
#    assert_response :success
#    assert_template 'error' , msg + "create_thread"  
#    
#    #list_changed
#    get :list_changed
#    assert_response :success
#    assert_template 'error' , msg + "list_changed"  
#    
#    #show_changed
#    get :show_changed
#    assert_response :success
#    assert_template 'error' , msg + "show_changed"  
#    
#    #list_file
#    get :list_file
#    assert_response :success
#    assert_template 'error' , msg + "list_file"  
#    
#    #upload
#    get :upload
#    assert_response :success
#    assert_template 'error' , msg + "upload"  
#    
#    #upload_file
#    get :upload_file
#    assert_response :success
#    assert_template 'error' , msg + "upload_file"  
#    
#    #download
#    get :download
#    assert_response :success
#    assert_template 'error' , msg + "download"  
#            
#    logout()                  
#  end
  
  def test_access_worker   
     
    #client    
    login_as('worker')     
        
    msg = "Worker don't have privileges to access client_requests/"
                        
    #new
    get :new
    assert_response :success
    assert_template 'error' , msg + "new"  
    
    #create
    get :create
    assert_response :success
    assert_template 'error' , msg + "create"  
            
    #edit
    get :edit
    assert_response :success
    assert_template 'error' , msg + "edit"  
    
    #update
    get :update
    assert_response :success
    assert_template 'error' , msg + "update"  
    
    #delete
    get :delete
    assert_response :success
    assert_template 'error' , msg + "delete"  
    
    #update_positions
    get :update_positions
    assert_response :success
    assert_template 'error' , msg + "update_positions"  
    
    #done_and_approved
    get :done_and_approved
    assert_response :success
    assert_template 'error' , msg + "done_and_approved"  
    
    #create_discussion
    get :create_discussion
    assert_response :success
    assert_template 'error' , msg + "create_discussion"  
    
       
    #delete_discussion
    get :delete_discussion
    assert_response :success
    assert_template 'error' , msg + "delete_discussion"  
        
    #create_thread
    get :create_thread
    assert_response :success
    assert_template 'error' , msg + "create_thread"  
            
    
    #upload
    get :upload
    assert_response :success
    assert_template 'error' , msg + "upload"  
    
    #upload_file
    get :upload_file
    assert_response :success
    assert_template 'error' , msg + "upload_file"  
                    
    logout()                  
  end
  
  def test_access_lead   
     
    #client    
    login_as('lead')     
        
    msg = "Lead don't have privileges to access client_requests/"
                
      #new
    get :new
    assert_response :success
    assert_template 'error' , msg + "new"  
    
    #create
    get :create
    assert_response :success
    assert_template 'error' , msg + "create"  
            
    #edit
    get :edit
    assert_response :success
    assert_template 'error' , msg + "edit"  
    
    #update
    get :update
    assert_response :success
    assert_template 'error' , msg + "update"  
    
    #delete
    get :delete
    assert_response :success
    assert_template 'error' , msg + "delete"  
    
    #update_positions
    get :update_positions
    assert_response :success
    assert_template 'error' , msg + "update_positions"  
    
    #done_and_approved
    get :done_and_approved
    assert_response :success
    assert_template 'error' , msg + "done_and_approved"  
    
    #create_discussion
    get :create_discussion
    assert_response :success
    assert_template 'error' , msg + "create_discussion"  
    
       
    #delete_discussion
    get :delete_discussion
    assert_response :success
    assert_template 'error' , msg + "delete_discussion"  
        
    #create_thread
    get :create_thread
    assert_response :success
    assert_template 'error' , msg + "create_thread"  
            
    
    #upload
    get :upload
    assert_response :success
    assert_template 'error' , msg + "upload"  
    
    #upload_file
    get :upload_file
    assert_response :success
    assert_template 'error' , msg + "upload_file"  
            
    logout()                  
  end

  def test_index
    get :index
    assert_response :redirect
  end
  
  def test_list_all
    get :list_all
    assert_response :success
    assert_template 'list_all'
  end
  
  def test_list_all_tab
    get :list_all_tab
    assert_response :success
    assert_template 'list_all_tab'
    
    assert_not_nil assigns(:projects)
  end
  
  def test_new
    get :new, :pid => 1
    assert_response :success
    assert_template 'new'
    
    assert_not_nil assigns(:project)
    assert_not_nil assigns(:client_request)
    assert_not_nil assigns(:req_options)
  end
  
  def test_create
    # OK	
    post :create,{:client_request => {:title => "abc", :hours => 3, :project_id => 1}}    
	assert_redirected_to :action => 'list'
    #assert_not_nil flash[:notice]
    #assert_equal 'ClientRequest was successfully created.', flash[:notice]
    #assert_redirected_to :action => 'list'
    
    # Error
    post :create, {:client_request => {:project_id => 1}}
    assert !assigns(:client_request).valid?
    assert_not_nil assigns(:client_request).errors.on(:title)
  end
  
  def test_show
    get :show, :id => 1
    
    assert_response :success
    assert_template 'show'
    
    assert_not_nil assigns(:client_request)
    assert_not_nil assigns(:req_changeds)
  end
  
  def test_edit
    post :edit, :id => 1
    assert_response :success
    assert_template 'edit'
    
    assert_not_nil assigns(:client_request)
    assert_not_nil assigns(:req_options)
    assert_not_nil assigns(:project)
  end
  
  def test_update
    post :update, {:id => 1, :client_request => {:title => 'new title'}}
    #assert_response :success
    assert_redirected_to :action => "show"
  end
  
  def test_delete
    id = 1
    assert_nothing_raised {
      ClientRequest.find(id)
    }
    post :delete, :id => id
    assert_response :redirect
    assert_redirected_to :action => 'list'
    
    # not found
    assert_raise(ActiveRecord::RecordNotFound){
      ClientRequest.find(id)
    }
  end
  
  def test_done_and_approved
    post :update, {:id => 1, :done_and_approved => true}
    assert_response :success
  end
  
end

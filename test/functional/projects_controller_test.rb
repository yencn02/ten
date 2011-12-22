require File.dirname(__FILE__) + '/../functional_test_helper'
require 'projects_controller'
include AuthenticatedTestHelper
include Arts

# Re-raise errors caught by the controller.
class ProjectsController; def rescue_action(e) raise e end; end

class ProjectsControllerTest < Test::Unit::TestCase
  fixtures :projects, :users, :roles, :roles_users, :upload_files, :discussion_threads, :discussions,:discussion_threads_users, :discussions_users
  
#  def test_access_sales    
#     
#    #client    
#    login_as('sales')     
#        
#    msg = "Sales don't have privileges to access projects/"
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
#    #show
#    get :show
#    assert_response :success
#    assert_template 'error' , msg + "show"  
#    
#    #update_users
#    get :update_users
#    assert_response :success
#    assert_template 'error' , msg + "update_users"  
#    
#    #update_auto_assignment
#    get :update_auto_assignment
#    assert_response :success
#    assert_template 'error' , msg + "update_auto_assignment"  
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
#    #create_thread
#    get :create_thread
#    assert_response :success
#    assert_template 'error' , msg + "create_thread"  
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
#    msg = "Payables don't have privileges to access projects/"
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
#    #show
#    get :show
#    assert_response :success
#    assert_template 'error' , msg + "show"  
#    
#    #update_users
#    get :update_users
#    assert_response :success
#    assert_template 'error' , msg + "update_users"  
#    
#    #update_auto_assignment
#    get :update_auto_assignment
#    assert_response :success
#    assert_template 'error' , msg + "update_auto_assignment"  
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
#    #create_thread
#    get :create_thread
#    assert_response :success
#    assert_template 'error' , msg + "create_thread"  
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
#    msg = "Handler don't have privileges to access projects/"
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
#    #show
#    get :show
#    assert_response :success
#    assert_template 'error' , msg + "show"  
#    
#    #update_users
#    get :update_users
#    assert_response :success
#    assert_template 'error' , msg + "update_users"  
#    
#    #update_auto_assignment
#    get :update_auto_assignment
#    assert_response :success
#    assert_template 'error' , msg + "update_auto_assignment"  
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
#    #create_thread
#    get :create_thread
#    assert_response :success
#    assert_template 'error' , msg + "create_thread"  
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
        
    msg = "Worker don't have privileges to access projects/"
                        
    #update_users
    get :update_users
    assert_response :success
    assert_template 'error' , msg + "update_users"  
    
    #update_auto_assignment
    get :update_auto_assignment
    assert_response :success
    assert_template 'error' , msg + "update_auto_assignment"  
    
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
        
    msg = "Lead don't have privileges to access projects/"
                        
    #update_users
    get :update_users
    assert_response :success
    assert_template 'error' , msg + "update_users"  
    
    #update_auto_assignment
    get :update_auto_assignment
    assert_response :success
    assert_template 'error' , msg + "update_auto_assignment"  
    
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

  def setup
    @controller = ProjectsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as('default')
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end
  
  def test_list
    get :list
    assert_response :success
    assert_template 'list'
    
    assert_not_nil assigns(:projects)
  end
  
  def test_list_with_params
    # sort by title
    get :list, :sort => 'title'
    assert_response :success
    assert_template 'list'
    assert_not_nil assigns(:projects)
    
    # sort by dateposted
    get :list, :sort => 'dateposted'
    assert_response :success
    assert_template 'list'
    assert_not_nil assigns(:projects)
    
    # sort by client_id
    get :list, :sort => 'client_id'
    assert_response :success
    assert_template 'list'
    assert_not_nil assigns(:projects)
  end
  
  def test_show
    get :show, :id => 1
    
    assert_response :success
    assert_template 'show'
    
    assert_not_nil assigns(:project)
    
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
  
  def test_update_users
    #post :update_users, {}
  end
  
  def test_update_auto_assignment
    post :update_auto_assignment, :id => 1
    assert_response :success
  end
  
  def test_new
    get :new
    assert_response :success
    assert_template 'new'
    
    assert_not_nil assigns(:user_role_names)
    assert_not_nil assigns(:user)
    assert_not_nil assigns(:project)
    assert_not_nil assigns(:clients)
  end
  
  def test_create
    # OK
    post :create, 
      {:project => {:title => "abc"}}
    assert_not_nil flash[:notice]
    assert_equal 'Projects was successfully created.', flash[:notice]
    assert_response :redirect
    assert_redirected_to :action => 'list'
    
    # Error
    post :create
    assert !assigns(:project).valid?
    assert_not_nil assigns(:project).errors.on(:title)
  end
  
  def test_edit
    post :edit, :id => 1
    assert_response :success
    assert_template 'edit'
    
    assert_not_nil assigns(:project)
    assert_not_nil assigns(:clients)
  end
  
  def test_update
    post :update, {:id => 1, :project => {:title => 'new title'}}
    assert_response :redirect
    assert_redirected_to :action => "show"
  end
  
  def test_delete
    id = 1
    assert_nothing_raised {
      Project.find(id)
    }
    post :delete, :id => id
    assert_response :redirect
    assert_redirected_to :action => 'list'
    
    # not found
    assert_raise(ActiveRecord::RecordNotFound){
      Project.find(id)
    }
  end

  def test_create_discussion
    post :create_discussion, :parent_id => 1
    assert_response :success
    assert_template 'shared/_create_discussion'
  end

  def test_create_discussion_rjs
      xhr :post, :create_discussion, :post => {:title => "Discussion", :body => "Discussion_body"}      
      assert_rjs :replace_html, 'discussion_area'
      assert_rjs :call, 'toggleElement', 'discuss_form_area'
      assert_rjs :call, 'toggleButtonById', 'sh_discussion', 'Create New Discussion', 'Hide discussion form'
  end
    
  def test_list_discussion
    get :list_discussion, :id => 1
    assert_response :success
    assert_template 'shared/_list_discussion'
  end
  
  def test_delete_discussion
    post :delete_discussion, :pid => 1 
    assert_response :success
    assert_template 'shared/_list_discussion'    
  end
  
  def test_create_thread
      xhr :post, :create_thread, 
        { :post => {:title => "Thread", :body => "Thread_body"},            
          :thread => { :content => "content"}, 
          :discussion_id => 1  }     
      assert_rjs :replace_html, 'thread_area'
      #assert_rjs :call, 'toggleElement', 'thread_form_area'
      #assert_rjs :call, 'toggleButtonById', 'sh_thread', 'Show thread form', 'Hide thread form'    
  end
  
  def test_list_thread
    # id : discussion id
    get :list_thread, :id => 1
    assert_response :success
    assert_template 'shared/_list_thread'    
  end
  
  def test_list_file
    # id: project_id
    get :list_file, :id => 1
    assert_response :success
    assert_template 'list_file'
    assert_not_nil assigns(:project)
  end
  
  def test_upload
    # id: project_id
    get :upload, :id => 1
    assert_response :success
    assert_template 'upload'
    assert_not_nil assigns(:project)    
  end
  
  def test_upload_file
    # id: project_id
    post :upload_file, 
      { :id => 1, 
        :upload => {:title => "FileUpload", :description => "FileUpload",        
                    :uploaded_data => fixture_file_upload('upload_files.yml', 'text/plain')
                    }                    
        }
    assert_equal 'File was successfully uploaded.', flash[:notice]
    assert_response :redirect
  end
  
  def test_download    
    assert true
    #upload_file_id = 1
    #file = UploadFile.find(upload_file_id)
    #get :download, :id => file
    #assert_response :success
  end
  
end

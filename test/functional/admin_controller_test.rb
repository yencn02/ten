require File.dirname(__FILE__) + '/../functional_test_helper'
require 'admin_controller'
include AuthenticatedTestHelper

# Re-raise errors caught by the controller.
class AdminController; def rescue_action(e) raise e end; end

class AdminControllerTest < Test::Unit::TestCase
  fixtures :users, :roles, :roles_users , :groups , :clients

  def setup
    @controller = AdminController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
   
   def test_access_client    
     
    #client    
    login_as('client')     
    
    id = 2
    group_id = 1
    assignment_id = 1
    msg = "Client don't have privileges to access admin/"
    
    #edit_client 
    post :edit_client , :id => id
    assert_response :success
    assert_template 'edit_client'
     
    #update_client
    post :update_client , :id => id , :user => {:address => "abc", :phone => "9097324" , :link => "client", :description => "desc"}  
    assert_response :redirect    
    assert_redirected_to :action => 'show_client'        
        
    #index
    get :index
    assert_response :success
    assert_template 'error' , msg + "index"  
    #list
    get :list  
    assert_response :success
    assert_template 'error' ,msg + "list"    
    #user_list
    get :user_list
    assert_response :success    
    assert_template 'error' , msg + "user_list"
            
    #keyword_new  
    get :keyword_new 
    assert_response :success
    assert_template 'error' , msg + "keyword_new"  
    
    #keyword_create 
    get :keyword_create 
    assert_response :success
    assert_template 'error' , msg + "keyword_create"  
    
    #keyword_delete 
    get :keyword_delete 
    assert_response :success
    assert_template 'error' , msg + "keyword_delete"   
    
    #keyword_edit 
    get :keyword_edit 
    assert_response :success
    assert_template 'error' , msg + "keyword_edit"   
    
    #keyword_update 
    get :keyword_update 
    assert_response :success
    assert_template 'error' ,msg + "keyword_update"   
    
    #keyword_update_status 
    get :keyword_update_status 
    assert_response :success
    assert_template 'error' , msg + "keyword_update_status"   
    
    #ass_verify
    get :ass_verify 
    assert_response :success
    assert_template 'error' , msg + "ass_verify" 
             
    #ass_paging_incomp
    get :ass_paging_incomp
    assert_response :success
    assert_template 'error' , msg + "ass_paging_incomp" 
     
    #ass_paging_not_verified
    get :ass_paging_not_verified
    assert_response :success
    assert_template 'error' , msg + "ass_paging_not_verified" 
    
    #ass_list 
    get :ass_list
    assert_response :success
    assert_template 'error' , msg + "ass_list" 
                     
    #edit    
    post :edit , :id => id
    assert_response :success
    assert_template 'error' , msg + "edit"  
    
    #update    
    post :update , :id => id
    assert_response :success
    assert_template 'error' , msg + "update"       
               
    #show    
    post :show , :id => id
    assert_response :success
    assert_template 'error' , msg + "show" 
    
    
    
    #client_list
    get :client_list
    assert_response :success    
    assert_template 'error' ,msg + "client_list"
    
    #user_ass
    get :user_ass
    assert_response :success    
    assert_template 'error' , msg + "user_ass"
    
    #keyword_list
    get :keyword_list    
    assert_response :success    
    assert_template 'error' , msg + "keyword_list" 
     
    #show_client        
    assert_nothing_raised {
      Client.find(2)
    }
    post :show_client , :id => 2
    assert_response :success
    assert_template 'error' , msg + "show_client"
    
    #ass_paging_verified
    post :ass_paging_verified , :id => id
    assert_response :success
    assert_template 'error' , msg + "ass_paging_verified" 
    
    #ass_undo_verify
    post :ass_undo_verify , :id => assignment_id
    assert_response :success , msg + "ass_undo_verify" 
    assert_template 'error' , msg + "ass_undo_verify"
            
    #show_ass    
    post :show_ass , :id => id
    assert_response :success
    assert_template 'error' , msg + "show_ass"

    #update_group_users
    post :update_groups_user , :id => group_id
    assert_response :success , msg + "update_groups_user"
    assert_template 'error' , msg + "update_groups_user"  
         
    #show_group    
    post :show_group , :id => group_id
    assert_response :success
    assert_template 'error' , msg + "show_group"
    
    #create_group
    post :create_group,
      {:group => {:name => "abc", :description => "desc"},:id => 'command'}    
    assert_response :success , msg + "create_group"   
    assert_template 'error' , msg + "create_group"
    
    #update_group
    post :update_group,
      {:group => {:name => "abc", :description => "desc"},:id => group_id}    
    assert_response :success , msg + "update_group"   
    assert_template 'error' , msg + "update_group"    
            
    #group_list
    get :group_list
    assert_response :success    
    assert_template 'error' , msg + "group_list"
    
    #delete_group    
    post :delete_group , :id => group_id
    assert_response :success , msg + "delete_group"    
    assert_template 'error' , msg + "delete_group"     
    
    #destroy    
    post :destroy , :id => id
    assert_response :success
    assert_template 'error' , msg + "destroy" 
    
    #destroy_client
    post :destroy_client , :id => id
    assert_response :success
    assert_template 'error' , msg + "destroy_client"       
    
    logout()                  
  end
  
   def test_access_sale    
     
    #client    
    login_as('sales')     
    
    id = 3
    group_id = 1
    assignment_id = 1
    msg = "Sale don't have privileges to access admin/"
    
    #edit_client 
    post :edit_client , :id => id
    assert_response :success
    assert_template 'error', msg + "edit_client"
     
    #update_client
    post :update_client , :id => id , :user => {:address => "abc", :phone => "9097324" , :link => "client", :description => "desc"}  
    assert_response :success
    assert_template 'error', msg + "update_client"     
        
    #index
    get :index
    assert_response :success
    assert_template 'error' , msg + "index"  
    #list
    get :list  
    assert_response :success
    assert_template 'error' ,msg + "list"    
    #user_list
    get :user_list
    assert_response :success    
    assert_template 'error' , msg + "user_list"
            
    #keyword_new  
    get :keyword_new 
    assert_response :success
    assert_template 'error' , msg + "keyword_new"  
    
    #keyword_create 
    get :keyword_create 
    assert_response :success
    assert_template 'error' , msg + "keyword_create"  
    
    #keyword_delete 
    get :keyword_delete 
    assert_response :success
    assert_template 'error' , msg + "keyword_delete"   
    
    #keyword_edit 
    get :keyword_edit 
    assert_response :success
    assert_template 'error' , msg + "keyword_edit"   
    
    #keyword_update 
    get :keyword_update 
    assert_response :success
    assert_template 'error' ,msg + "keyword_update"   
    
    #keyword_update_status 
    get :keyword_update_status 
    assert_response :success
    assert_template 'error' , msg + "keyword_update_status"   
    
    #ass_verify
    get :ass_verify 
    assert_response :success
    assert_template 'error' , msg + "ass_verify" 
             
    #ass_paging_incomp
    get :ass_paging_incomp
    assert_response :success
    assert_template 'error' , msg + "ass_paging_incomp" 
     
    #ass_paging_not_verified
    get :ass_paging_not_verified
    assert_response :success
    assert_template 'error' , msg + "ass_paging_not_verified" 
    
    #ass_list 
    get :ass_list
    assert_response :success
    assert_template 'error' , msg + "ass_list" 
                     
    #edit    
    post :edit , :id => id
    assert_response :success
    assert_template 'error' , msg + "edit"  
    
    #update    
    post :update , :id => id
    assert_response :success
    assert_template 'error' , msg + "update"       
               
    #show    
    post :show , :id => id
    assert_response :success
    assert_template 'error' , msg + "show" 
            
    #client_list
    get :client_list
    assert_response :success    
    assert_template 'error' ,msg + "client_list"
    
    #user_ass
    get :user_ass
    assert_response :success    
    assert_template 'error' , msg + "user_ass"
    
    #keyword_list
    get :keyword_list    
    assert_response :success    
    assert_template 'error' , msg + "keyword_list" 
             
              
    #destroy    
    post :destroy , :id => id
    assert_response :success
    assert_template 'error' , msg + "destroy" 
    
    #destroy_client
    post :destroy_client , :id => id
    assert_response :success
    assert_template 'error' , msg + "destroy_client"       
    
    #ass_paging_verified
    post :ass_paging_verified , :id => id
    assert_response :success
    assert_template 'error' , msg + "ass_paging_verified" 
    
    #ass_undo_verify
    post :ass_undo_verify , :id => assignment_id
    assert_response :success , msg + "ass_undo_verify" 
    assert_template 'error' , msg + "ass_undo_verify"
            
    #show_ass    
    post :show_ass , :id => id
    assert_response :success
    assert_template 'error' , msg + "show_ass"

    #update_group_users
    post :update_groups_user , :id => group_id
    assert_response :success , msg + "update_groups_user"
    assert_template 'error' , msg + "update_groups_user"  
         
    #show_group    
    post :show_group , :id => group_id
    assert_response :success
    assert_template 'error' , msg + "show_group"
    
    #create_group
    post :create_group,
      {:group => {:name => "abc", :description => "desc"},:id => 'command'}    
    assert_response :success , msg + "create_group"   
    assert_template 'error' , msg + "create_group"
    
    #update_group
    post :update_group,
      {:group => {:name => "abc", :description => "desc"},:id => group_id}    
    assert_response :success , msg + "update_group"   
    assert_template 'error' , msg + "update_group"    
            
    #group_list
    get :group_list
    assert_response :success    
    assert_template 'error' , msg + "group_list"
    
    #show_client        
    assert_nothing_raised {
      Client.find(2)
    }
    post :show_client , :id => 2
    assert_response :success
    assert_template 'error' , msg + "show_client"      
    
    #delete_group    
    post :delete_group , :id => group_id
    assert_response :success , msg + "delete_group"    
    assert_template 'error' , msg + "delete_group"     
    
    
    logout()                  
  end  
  
   def test_access_handler    
     
    #client    
    login_as('handler')     
    
    id = 4
    group_id = 1
    assignment_id = 1
    msg = "Handler don't have privileges to access admin/"
    
    #edit_client 
    post :edit_client , :id => id
    assert_response :success
    assert_template 'error', msg + "edit_client"
     
    #update_client
    post :update_client , :id => id , :user => {:address => "abc", :phone => "9097324" , :link => "client", :description => "desc"}  
    assert_response :success
    assert_template 'error', msg + "update_client"     
        
    #index
    get :index
    assert_response :success
    assert_template 'error' , msg + "index"  
    #list
    get :list  
    assert_response :success
    assert_template 'error' ,msg + "list"    
    #user_list
    get :user_list
    assert_response :success    
    assert_template 'error' , msg + "user_list"
            
    #keyword_new  
    get :keyword_new 
    assert_response :success
    assert_template 'error' , msg + "keyword_new"  
    
    #keyword_create 
    get :keyword_create 
    assert_response :success
    assert_template 'error' , msg + "keyword_create"  
    
    #keyword_delete 
    get :keyword_delete 
    assert_response :success
    assert_template 'error' , msg + "keyword_delete"   
    
    #keyword_edit 
    get :keyword_edit 
    assert_response :success
    assert_template 'error' , msg + "keyword_edit"   
    
    #keyword_update 
    get :keyword_update 
    assert_response :success
    assert_template 'error' ,msg + "keyword_update"   
    
    #keyword_update_status 
    get :keyword_update_status 
    assert_response :success
    assert_template 'error' , msg + "keyword_update_status"   
    
    #ass_verify
    get :ass_verify 
    assert_response :success
    assert_template 'error' , msg + "ass_verify" 
             
    #ass_paging_incomp
    get :ass_paging_incomp
    assert_response :success
    assert_template 'error' , msg + "ass_paging_incomp" 
     
    #ass_paging_not_verified
    get :ass_paging_not_verified
    assert_response :success
    assert_template 'error' , msg + "ass_paging_not_verified" 
    
    #ass_list 
    get :ass_list
    assert_response :success
    assert_template 'error' , msg + "ass_list" 
                     
    #edit    
    post :edit , :id => id
    assert_response :success
    assert_template 'error' , msg + "edit"  
    
    #update    
    post :update , :id => id
    assert_response :success
    assert_template 'error' , msg + "update"       
               
    #show    
    post :show , :id => id
    assert_response :success
    assert_template 'error' , msg + "show" 
            
    #client_list
    get :client_list
    assert_response :success    
    assert_template 'error' ,msg + "client_list"
    
    #user_ass
    get :user_ass
    assert_response :success    
    assert_template 'error' , msg + "user_ass"
    
    #keyword_list
    get :keyword_list    
    assert_response :success    
    assert_template 'error' , msg + "keyword_list" 
             
              
    #destroy    
    post :destroy , :id => id
    assert_response :success
    assert_template 'error' , msg + "destroy" 
    
    #destroy_client
    post :destroy_client , :id => id
    assert_response :success
    assert_template 'error' , msg + "destroy_client"       
    
    #ass_undo_verify
    post :ass_undo_verify , :id => assignment_id
    assert_response :success , msg + "ass_undo_verify" 
    assert_template 'error' , msg + "ass_undo_verify"      
                            
    #show_ass    
    post :show_ass , :id => id
    assert_response :success
    assert_template 'error' , msg + "show_ass"

    #update_group_users
    post :update_groups_user , :id => group_id
    assert_response :success , msg + "update_groups_user"
    assert_template 'error' , msg + "update_groups_user"  
         
    #show_group    
    post :show_group , :id => group_id
    assert_response :success
    assert_template 'error' , msg + "show_group"
    
    #create_group
    post :create_group,
      {:group => {:name => "abc", :description => "desc"},:id => 'command'}    
    assert_response :success , msg + "create_group"   
    assert_template 'error' , msg + "create_group"
    
    #update_group
    post :update_group,
      {:group => {:name => "abc", :description => "desc"},:id => group_id}    
    assert_response :success , msg + "update_group"   
    assert_template 'error' , msg + "update_group"    
            
    #group_list
    get :group_list
    assert_response :success    
    assert_template 'error' , msg + "group_list"
    
    #show_client        
    assert_nothing_raised {
      Client.find(2)
    }
    post :show_client , :id => 2
    assert_response :success
    assert_template 'error' , msg + "show_client"   

    #ass_paging_verified
    post :ass_paging_verified , :id => id
    assert_response :success
    assert_template 'error' , msg + "ass_paging_verified" 
    
    #delete_group    
    post :delete_group , :id => group_id
    assert_response :success , msg + "delete_group"    
    assert_template 'error' , msg + "delete_group"     
    
    
    logout()                  
  end  
  
   def test_access_worker    
     
    #client    
    login_as('worker')     
    
    id = 5
    group_id = 1
    assignment_id = 1
    msg = "Worker don't have privileges to access admin/"
    
    #edit_client 
    post :edit_client , :id => id
    assert_response :success
    assert_template 'error', msg + "edit_client"
     
    #update_client
    post :update_client , :id => id , :user => {:address => "abc", :phone => "9097324" , :link => "client", :description => "desc"}  
    assert_response :success
    assert_template 'error', msg + "update_client"     
        
    #index
    get :index
    assert_response :success
    assert_template 'error' , msg + "index"  
    #list
    get :list  
    assert_response :success
    assert_template 'error' ,msg + "list"    
    #user_list
    get :user_list
    assert_response :success    
    assert_template 'error' , msg + "user_list"
            
    #keyword_new  
    get :keyword_new 
    assert_response :success
    assert_template 'error' , msg + "keyword_new"  
    
    #keyword_create 
    get :keyword_create 
    assert_response :success
    assert_template 'error' , msg + "keyword_create"  
    
    #keyword_delete 
    get :keyword_delete 
    assert_response :success
    assert_template 'error' , msg + "keyword_delete"   
    
    #keyword_edit 
    get :keyword_edit 
    assert_response :success
    assert_template 'error' , msg + "keyword_edit"   
    
    #keyword_update 
    get :keyword_update 
    assert_response :success
    assert_template 'error' ,msg + "keyword_update"   
    
    #keyword_update_status 
    get :keyword_update_status 
    assert_response :success
    assert_template 'error' , msg + "keyword_update_status"   
    
    #ass_verify
    get :ass_verify 
    assert_response :success
    assert_template 'error' , msg + "ass_verify" 
             
    #ass_paging_incomp
    get :ass_paging_incomp
    assert_response :success
    assert_template 'error' , msg + "ass_paging_incomp" 
     
    #ass_paging_not_verified
    get :ass_paging_not_verified
    assert_response :success
    assert_template 'error' , msg + "ass_paging_not_verified" 
    
    #ass_list 
    get :ass_list
    assert_response :success
    assert_template 'error' , msg + "ass_list" 
                     
    #edit    
    post :edit , :id => id
    assert_response :success
    assert_template 'error' , msg + "edit"  
    
    #update    
    post :update , :id => id
    assert_response :success
    assert_template 'error' , msg + "update"       
               
    #show    
    post :show , :id => id
    assert_response :success
    assert_template 'error' , msg + "show" 
            
    #client_list
    get :client_list
    assert_response :success    
    assert_template 'error' ,msg + "client_list"
    
    #user_ass
    get :user_ass
    assert_response :success    
    assert_template 'error' , msg + "user_ass"
    
    #keyword_list
    get :keyword_list    
    assert_response :success    
    assert_template 'error' , msg + "keyword_list" 
             
              
    #destroy    
    post :destroy , :id => id
    assert_response :success
    assert_template 'error' , msg + "destroy" 
    
    #destroy_client
    post :destroy_client , :id => id
    assert_response :success
    assert_template 'error' , msg + "destroy_client"       
                                        
    #show_ass    
    post :show_ass , :id => id
    assert_response :success
    assert_template 'error' , msg + "show_ass"

    #update_group_users
    post :update_groups_user , :id => group_id
    assert_response :success , msg + "update_groups_user"
    assert_template 'error' , msg + "update_groups_user"  
         
    #show_group    
    post :show_group , :id => group_id
    assert_response :success
    assert_template 'error' , msg + "show_group"
    
    #create_group
    post :create_group,
      {:group => {:name => "abc", :description => "desc"},:id => 'command'}    
    assert_response :success , msg + "create_group"   
    assert_template 'error' , msg + "create_group"
    
    #update_group
    post :update_group,
      {:group => {:name => "abc", :description => "desc"},:id => group_id}    
    assert_response :success , msg + "update_group"   
    assert_template 'error' , msg + "update_group"    
            
    #group_list
    get :group_list
    assert_response :success    
    assert_template 'error' , msg + "group_list"
    
    #show_client        
    assert_nothing_raised {
      Client.find(2)
    }
    post :show_client , :id => 2
    assert_response :success
    assert_template 'error' , msg + "show_client"   

    #ass_paging_verified
    post :ass_paging_verified , :id => id
    assert_response :success
    assert_template 'error' , msg + "ass_paging_verified" 
    
    #ass_undo_verify
    post :ass_undo_verify , :id => assignment_id
    assert_response :success , msg + "ass_undo_verify" 
    assert_template 'error' , msg + "ass_undo_verify"  
    
    #delete_group    
    post :delete_group , :id => group_id
    assert_response :success , msg + "delete_group"    
    assert_template 'error' , msg + "delete_group"     
    
    
    logout()                  
  end  
  
   def test_access_payables    
     
    #client    
    login_as('payables')     
    
    id = 6
    group_id = 1
    assignment_id = 1
    msg = "Payables don't have privileges to access admin/"
    
    #edit_client 
    post :edit_client , :id => id
    assert_response :success
    assert_template 'error', msg + "edit_client"
     
    #update_client
    post :update_client , :id => id , :user => {:address => "abc", :phone => "9097324" , :link => "client", :description => "desc"}  
    assert_response :success
    assert_template 'error', msg + "update_client"     
        
    #index
    get :index
    assert_response :success
    assert_template 'error' , msg + "index"  
    #list
    get :list  
    assert_response :success
    assert_template 'error' ,msg + "list"    
    #user_list
    get :user_list
    assert_response :success    
    assert_template 'error' , msg + "user_list"
            
    #keyword_new  
    get :keyword_new 
    assert_response :success
    assert_template 'error' , msg + "keyword_new"  
    
    #keyword_create 
    get :keyword_create 
    assert_response :success
    assert_template 'error' , msg + "keyword_create"  
    
    #keyword_delete 
    get :keyword_delete 
    assert_response :success
    assert_template 'error' , msg + "keyword_delete"   
    
    #keyword_edit 
    get :keyword_edit 
    assert_response :success
    assert_template 'error' , msg + "keyword_edit"   
    
    #keyword_update 
    get :keyword_update 
    assert_response :success
    assert_template 'error' ,msg + "keyword_update"   
    
    #keyword_update_status 
    get :keyword_update_status 
    assert_response :success
    assert_template 'error' , msg + "keyword_update_status"   
    
    #ass_verify
    get :ass_verify 
    assert_response :success
    assert_template 'error' , msg + "ass_verify" 
             
    #ass_paging_incomp
    get :ass_paging_incomp
    assert_response :success
    assert_template 'error' , msg + "ass_paging_incomp" 
     
    #ass_paging_not_verified
    get :ass_paging_not_verified
    assert_response :success
    assert_template 'error' , msg + "ass_paging_not_verified" 
    
    #ass_list 
    get :ass_list
    assert_response :success
    assert_template 'error' , msg + "ass_list" 
                     
    #edit    
    post :edit , :id => id
    assert_response :success
    assert_template 'error' , msg + "edit"  
    
    #update    
    post :update , :id => id
    assert_response :success
    assert_template 'error' , msg + "update"       
               
    #show    
    post :show , :id => id
    assert_response :success
    assert_template 'error' , msg + "show" 
            
    #client_list
    get :client_list
    assert_response :success    
    assert_template 'error' ,msg + "client_list"
    
    #user_ass
    get :user_ass
    assert_response :success    
    assert_template 'error' , msg + "user_ass"
    
    #keyword_list
    get :keyword_list    
    assert_response :success    
    assert_template 'error' , msg + "keyword_list" 
             
              
    #destroy    
    post :destroy , :id => id
    assert_response :success
    assert_template 'error' , msg + "destroy" 
    
    #destroy_client
    post :destroy_client , :id => id
    assert_response :success
    assert_template 'error' , msg + "destroy_client"       
                                       
    
    #update_group_users
    post :update_groups_user , :id => group_id
    assert_response :success , msg + "update_groups_user"
    assert_template 'error' , msg + "update_groups_user"  
         
    #show_group    
    post :show_group , :id => group_id
    assert_response :success
    assert_template 'error' , msg + "show_group"
    
    #create_group
    post :create_group,
      {:group => {:name => "abc", :description => "desc"},:id => 'command'}    
    assert_response :success , msg + "create_group"   
    assert_template 'error' , msg + "create_group"
    
    #update_group
    post :update_group,
      {:group => {:name => "abc", :description => "desc"},:id => group_id}    
    assert_response :success , msg + "update_group"   
    assert_template 'error' , msg + "update_group"    
            
    #group_list
    get :group_list
    assert_response :success    
    assert_template 'error' , msg + "group_list"
    
    #show_client        
    assert_nothing_raised {
      Client.find(2)
    }
    post :show_client , :id => 2
    assert_response :success
    assert_template 'error' , msg + "show_client"   

    #ass_paging_verified
    post :ass_paging_verified , :id => id
    assert_response :success
    assert_template 'error' , msg + "ass_paging_verified" 
    
    #ass_undo_verify
    post :ass_undo_verify , :id => assignment_id
    assert_response :success , msg + "ass_undo_verify" 
    assert_template 'error' , msg + "ass_undo_verify"  
    
    #show_ass    
    post :show_ass , :id => id
    assert_response :success
    assert_template 'error' , msg + "show_ass" 
    
    #delete_group    
    post :delete_group , :id => group_id
    assert_response :success , msg + "delete_group"    
    assert_template 'error' , msg + "delete_group"     
    
    
    logout()                  
  end  
  
   def test_access_lead    
     
    #client    
    login_as('lead')     
    
    id = 7
    group_id = 1
    assignment_id = 1
    msg = "Lead don't have privileges to access admin/"
    
    #edit_client 
    post :edit_client , :id => id
    assert_response :success
    assert_template 'error', msg + "edit_client"
     
    #update_client
    post :update_client , :id => id , :user => {:address => "abc", :phone => "9097324" , :link => "client", :description => "desc"}  
    assert_response :success
    assert_template 'error', msg + "update_client"     
        
    #index
    get :index
    assert_response :success
    assert_template 'error' , msg + "index"  
    #list
    get :list  
    assert_response :success
    assert_template 'error' ,msg + "list"    
    #user_list
    get :user_list
    assert_response :success    
    assert_template 'error' , msg + "user_list"
            
    #keyword_new  
    get :keyword_new 
    assert_response :success
    assert_template 'error' , msg + "keyword_new"  
    
    #keyword_create 
    get :keyword_create 
    assert_response :success
    assert_template 'error' , msg + "keyword_create"  
    
    #keyword_delete 
    get :keyword_delete 
    assert_response :success
    assert_template 'error' , msg + "keyword_delete"   
    
    #keyword_edit 
    get :keyword_edit 
    assert_response :success
    assert_template 'error' , msg + "keyword_edit"   
    
    #keyword_update 
    get :keyword_update 
    assert_response :success
    assert_template 'error' ,msg + "keyword_update"   
    
    #keyword_update_status 
    get :keyword_update_status 
    assert_response :success
    assert_template 'error' , msg + "keyword_update_status"   
    
    #ass_verify
    get :ass_verify 
    assert_response :success
    assert_template 'error' , msg + "ass_verify" 
             
    #ass_paging_incomp
    get :ass_paging_incomp
    assert_response :success
    assert_template 'error' , msg + "ass_paging_incomp" 
     
    #ass_paging_not_verified
    get :ass_paging_not_verified
    assert_response :success
    assert_template 'error' , msg + "ass_paging_not_verified" 
    
    #ass_list 
    get :ass_list
    assert_response :success
    assert_template 'error' , msg + "ass_list" 
                     
    #edit    
    post :edit , :id => id
    assert_response :success
    assert_template 'error' , msg + "edit"  
    
    #update    
    post :update , :id => id
    assert_response :success
    assert_template 'error' , msg + "update"       
               
    #show    
    post :show , :id => id
    assert_response :success
    assert_template 'error' , msg + "show" 
            
    #client_list
    get :client_list
    assert_response :success    
    assert_template 'error' ,msg + "client_list"
    
    #user_ass
    get :user_ass
    assert_response :success    
    assert_template 'error' , msg + "user_ass"
    
    #keyword_list
    get :keyword_list    
    assert_response :success    
    assert_template 'error' , msg + "keyword_list" 
             
              
    #destroy    
    post :destroy , :id => id
    assert_response :success
    assert_template 'error' , msg + "destroy" 
    
    #destroy_client
    post :destroy_client , :id => id
    assert_response :success
    assert_template 'error' , msg + "destroy_client"       
                                                        
    #show_group    
    post :show_group , :id => group_id
    assert_response :success
    assert_template 'error' , msg + "show_group"
    
    #create_group
    post :create_group,
      {:group => {:name => "abc", :description => "desc"},:id => 'command'}    
    assert_response :success , msg + "create_group"   
    assert_template 'error' , msg + "create_group"
    
    #update_group
    post :update_group,
      {:group => {:name => "abc", :description => "desc"},:id => group_id}    
    assert_response :success , msg + "update_group"   
    assert_template 'error' , msg + "update_group"    
            
    #group_list
    get :group_list
    assert_response :success    
    assert_template 'error' , msg + "group_list"
    
    #show_client        
    assert_nothing_raised {
      Client.find(2)
    }
    post :show_client , :id => 2
    assert_response :success
    assert_template 'error' , msg + "show_client"   

    #ass_paging_verified
    post :ass_paging_verified , :id => id
    assert_response :success
    assert_template 'error' , msg + "ass_paging_verified" 
    
    #ass_undo_verify
    post :ass_undo_verify , :id => assignment_id
    assert_response :success , msg + "ass_undo_verify" 
    assert_template 'error' , msg + "ass_undo_verify"  
    
    #show_ass    
    post :show_ass , :id => id
    assert_response :success
    assert_template 'error' , msg + "show_ass" 
    
    #update_group_users
    post :update_groups_user , :id => group_id
    assert_response :success , msg + "update_groups_user"
    assert_template 'error' , msg + "update_groups_user"       
    
    #delete_group    
    post :delete_group , :id => group_id
    assert_response :success , msg + "delete_group"    
    assert_template 'error' , msg + "delete_group"     
    
    
    logout()                  
  end  
  
   def test_access_clientservice    
     
    #client    
    login_as('clientservice')     
    
    id = 8
    group_id = 1
    assignment_id = 1
    msg = "Clientservice don't have privileges to access admin/"
    
    #edit_client 
    post :edit_client , :id => id
    assert_response :success
    assert_template 'error', msg + "edit_client"
     
    #update_client
    post :update_client , :id => id , :user => {:address => "abc", :phone => "9097324" , :link => "client", :description => "desc"}  
    assert_response :success
    assert_template 'error', msg + "update_client"     
        
    #index
    get :index
    assert_response :success
    assert_template 'error' , msg + "index"  
    #list
    get :list  
    assert_response :success
    assert_template 'error' ,msg + "list"    
    #user_list
    get :user_list
    assert_response :success    
    assert_template 'error' , msg + "user_list"
            
    #keyword_new  
    get :keyword_new 
    assert_response :success
    assert_template 'error' , msg + "keyword_new"  
    
    #keyword_create 
    get :keyword_create 
    assert_response :success
    assert_template 'error' , msg + "keyword_create"  
    
    #keyword_delete 
    get :keyword_delete 
    assert_response :success
    assert_template 'error' , msg + "keyword_delete"   
    
    #keyword_edit 
    get :keyword_edit 
    assert_response :success
    assert_template 'error' , msg + "keyword_edit"   
    
    #keyword_update 
    get :keyword_update 
    assert_response :success
    assert_template 'error' ,msg + "keyword_update"   
    
    #keyword_update_status 
    get :keyword_update_status 
    assert_response :success
    assert_template 'error' , msg + "keyword_update_status"   
    
    #ass_verify
    get :ass_verify 
    assert_response :success
    assert_template 'error' , msg + "ass_verify" 
             
    #ass_paging_incomp
    get :ass_paging_incomp
    assert_response :success
    assert_template 'error' , msg + "ass_paging_incomp" 
     
    #ass_paging_not_verified
    get :ass_paging_not_verified
    assert_response :success
    assert_template 'error' , msg + "ass_paging_not_verified" 
    
    #ass_list 
    get :ass_list
    assert_response :success
    assert_template 'error' , msg + "ass_list" 
                     
    #edit    
    post :edit , :id => id
    assert_response :success
    assert_template 'error' , msg + "edit"  
    
    #update    
    post :update , :id => id
    assert_response :success
    assert_template 'error' , msg + "update"       
               
    #show    
    post :show , :id => id
    assert_response :success
    assert_template 'error' , msg + "show" 
            
    #client_list
    get :client_list
    assert_response :success    
    assert_template 'error' ,msg + "client_list"
    
    #user_ass
    get :user_ass
    assert_response :success    
    assert_template 'error' , msg + "user_ass"
    
    #keyword_list
    get :keyword_list    
    assert_response :success    
    assert_template 'error' , msg + "keyword_list" 
             
              
    #destroy    
    post :destroy , :id => id
    assert_response :success
    assert_template 'error' , msg + "destroy" 
    
    #destroy_client
    post :destroy_client , :id => id
    assert_response :success
    assert_template 'error' , msg + "destroy_client"       
                                                                
    #create_group
    post :create_group,
      {:group => {:name => "abc", :description => "desc"},:id => 'command'}    
    assert_response :success , msg + "create_group"   
    assert_template 'error' , msg + "create_group"
    
    #update_group
    post :update_group,
      {:group => {:name => "abc", :description => "desc"},:id => group_id}    
    assert_response :success , msg + "update_group"   
    assert_template 'error' , msg + "update_group"    
            
    #group_list
    get :group_list
    assert_response :success    
    assert_template 'error' , msg + "group_list"
    
    #show_client        
    assert_nothing_raised {
      Client.find(2)
    }
    post :show_client , :id => 2
    assert_response :success
    assert_template 'error' , msg + "show_client"   

    #ass_paging_verified
    post :ass_paging_verified , :id => id
    assert_response :success
    assert_template 'error' , msg + "ass_paging_verified" 
    
    #ass_undo_verify
    post :ass_undo_verify , :id => assignment_id
    assert_response :success , msg + "ass_undo_verify" 
    assert_template 'error' , msg + "ass_undo_verify"  
    
    #show_ass    
    post :show_ass , :id => id
    assert_response :success
    assert_template 'error' , msg + "show_ass" 
    
    #update_group_users
    post :update_groups_user , :id => group_id
    assert_response :success , msg + "update_groups_user"
    assert_template 'error' , msg + "update_groups_user"       
    
    #show_group    
    post :show_group , :id => group_id
    assert_response :success
    assert_template 'error' , msg + "show_group"
    
    #delete_group    
    post :delete_group , :id => group_id
    assert_response :success , msg + "delete_group"    
    assert_template 'error' , msg + "delete_group"     
    
    
    logout()                  
  end  
end

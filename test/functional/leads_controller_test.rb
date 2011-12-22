require File.dirname(__FILE__) + '/../functional_test_helper'
require 'leads_controller'
include AuthenticatedTestHelper

# Re-raise errors caught by the controller.
class LeadsController; def rescue_action(e) raise e end; end

class LeadsControllerTest < Test::Unit::TestCase
  fixtures :leads,:users, :roles, :roles_users

  def setup
    @controller = LeadsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    #@first_id = leads(:first).id
  end

  def test_access_client    
     
    #client    
    login_as('client')     
       
    msg = "Client don't have privileges to access lead/"
    
    #new
    get :new
    assert_response :success
    assert_template 'error' , msg + "new"  
    
    #show
    get :show
    assert_response :success
    assert_template 'error' , msg + "show"  
   
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
    
    #destroy
    get :destroy
    assert_response :success
    assert_template 'error' , msg + "destroy"  
       
    
                   
    
    logout()                  
  end
  
  def test_access_worker    
     
    #client    
    login_as('worker')     
       
    msg = "Worker don't have privileges to access lead/"
    
    #new
    get :new
    assert_response :success
    assert_template 'error' , msg + "new"  
    
    #show
    get :show
    assert_response :success
    assert_template 'error' , msg + "show"  
   
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
    
    #destroy
    get :destroy
    assert_response :success
    assert_template 'error' , msg + "destroy"  
       
    
                   
    
    logout()                  
  end
 
#  def test_access_handler    
#     
    #client    
#    login_as('handler')     
#       
#    msg = "Handler don't have privileges to access lead/"
#    
    #new
#    get :new
#    assert_response :success
#    assert_template 'error' , msg + "new"  
#    
    #show
#    get :show
#    assert_response :success
#    assert_template 'error' , msg + "show"  
#   
    #create
#    get :create
#    assert_response :success
#    assert_template 'error' , msg + "create"   
#   
    #edit
#    get :edit
#    assert_response :success
#    assert_template 'error' , msg + "edit"   
#   
    #update
#    get :update
#    assert_response :success
#    assert_template 'error' , msg + "update"  
#    
    #destroy
#    get :destroy
#    assert_response :success
#    assert_template 'error' , msg + "destroy"  
#       
#    
#                   
#    
#    logout()                  
#  end
  
#  def test_access_payables    
#     
    #client    
#    login_as('payables')     
#       
#    msg = "Payables don't have privileges to access lead/"
#    
    #new
#    get :new
#    assert_response :success
#    assert_template 'error' , msg + "new"  
#    
    #show
#    get :show
#    assert_response :success
#    assert_template 'error' , msg + "show"  
#   
    #create
#    get :create
#    assert_response :success
#    assert_template 'error' , msg + "create"   
#   
    #edit
#    get :edit
#    assert_response :success
#    assert_template 'error' , msg + "edit"   
#   
    #update
#    get :update
#    assert_response :success
#    assert_template 'error' , msg + "update"  
#    
    #destroy
#    get :destroy
#    assert_response :success
#    assert_template 'error' , msg + "destroy"  
#       
#    
#                   
#    
#    logout()                  
#  end
  
  def test_access_lead    
     
    #client    
    login_as('lead')     
       
    msg = "Lead don't have privileges to access lead/"
    
    #new
    get :new
    assert_response :success
    assert_template 'error' , msg + "new"  
    
    #show
    get :show
    assert_response :success
    assert_template 'error' , msg + "show"  
   
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
    
    #destroy
    get :destroy
    assert_response :success
    assert_template 'error' , msg + "destroy"  
       
    
                   
    
    logout()                  
  end
  
#  def test_access_clientservice    
#     
    #client    
#    login_as('clientservice')     
#       
#    msg = "Clientservice don't have privileges to access lead/"
#    
    #new
#    get :new
#    assert_response :success
#    assert_template 'error' , msg + "new"  
#    
    #show
#    get :show
#    assert_response :success
#    assert_template 'error' , msg + "show"  
#   
    #create
#    get :create
#    assert_response :success
#    assert_template 'error' , msg + "create"   
#   
    #edit
#    get :edit
#    assert_response :success
#    assert_template 'error' , msg + "edit"   
#   
    #update
#    get :update
#    assert_response :success
#    assert_template 'error' , msg + "update"  
#    
    #destroy
#    get :destroy
#    assert_response :success
#    assert_template 'error' , msg + "destroy"  
#       
#    
#                   
#    
#    logout()                  
#  end
end

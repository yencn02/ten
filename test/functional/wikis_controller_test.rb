require File.dirname(__FILE__) + '/../functional_test_helper'
require 'wikis_controller'
include AuthenticatedTestHelper

# Re-raise errors caught by the controller.
class WikisController; def rescue_action(e) raise e end; end

class WikisControllerTest < ActionController::TestCase
  
  fixtures :users, :roles, :roles_users

  def setup
    @controller = WikisController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def test_access_client    
     
    #client    
    login_as('client')     
        
    msg = "Client don't have privileges to access wikis/"
        
    #new
    get :new
    assert_response :success
    assert_template 'error' , msg + "new"  
    
    #create
    get :create
    assert_response :success
    assert_template 'error' , msg + "new"  
    
    #edit
    get :edit
    assert_response :success
    assert_template 'error' , msg + "edit"  
    
    #update
    get :update
    assert_response :success
    assert_template 'error' , msg + "update"  
    
  end
  
  def test_access_sale    
     
    #client    
    login_as('sales')     
        
    msg = "Sales don't have privileges to access wikis/"
        
    #new
    get :new
    assert_response :success
    assert_template 'error' , msg + "new"  
    
    #create
    get :create
    assert_response :success
    assert_template 'error' , msg + "new"  
    
    #edit
    get :edit
    assert_response :success
    assert_template 'error' , msg + "edit"  
    
    #update
    get :update
    assert_response :success
    assert_template 'error' , msg + "update"  
    
  end
  
  def test_access_worker    
     
    #client    
    login_as('worker')     
        
    msg = "Worker don't have privileges to access wikis/"
        
    #new
    get :new
    assert_response :success
    assert_template 'error' , msg + "new"  
    
    #create
    get :create
    assert_response :success
    assert_template 'error' , msg + "new"  
    
    #edit
    get :edit
    assert_response :success
    assert_template 'error' , msg + "edit"  
    
    #update
    get :update
    assert_response :success
    assert_template 'error' , msg + "update"  
    
  end
  
  def test_access_payables    
     
    #client    
    login_as('payables')     
        
    msg = "Payables don't have privileges to access wikis/"
        
    #new
    get :new
    assert_response :success
    assert_template 'error' , msg + "new"  
    
    #create
    get :create
    assert_response :success
    assert_template 'error' , msg + "new"  
    
    #edit
    get :edit
    assert_response :success
    assert_template 'error' , msg + "edit"  
    
    #update
    get :update
    assert_response :success
    assert_template 'error' , msg + "update"  
    
  end
  
  def test_access_clientservice    
     
    #client    
    login_as('clientservice')     
        
    msg = "Clientservice don't have privileges to access wikis/"
        
    #new
    get :new
    assert_response :success
    assert_template 'error' , msg + "new"  
    
    #create
    get :create
    assert_response :success
    assert_template 'error' , msg + "new"  
    
    #edit
    get :edit
    assert_response :success
    assert_template 'error' , msg + "edit"  
    
    #update
    get :update
    assert_response :success
    assert_template 'error' , msg + "update"  
    
  end
end

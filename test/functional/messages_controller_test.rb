require File.dirname(__FILE__) + '/../functional_test_helper'
require 'messages_controller'
include AuthenticatedTestHelper

# Re-raise errors caught by the controller.
class MessagesController; def rescue_action(e) raise e end; end

class MessagesControllerTest < Test::Unit::TestCase
  fixtures :messages, :message_aliases, :users, :roles, :roles_users
  
  def setup
    @controller = MessagesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    login_as('default')
  end

  def test_index
    get :index
    assert_response :redirect
    assert_redirected_to :action => 'list_all'
  end
  
  def test_list
    get :list
    assert_redirected_to :action => 'list_all'
    #assert_template 'list'
  end
  
  def test_list_all
    get :list_all
    assert_response :success
    assert_template 'list_all'
  end

    
  def test_list_message
    get :list_message
    assert_response :success
    assert_template 'list_message'
    
    assert_not_nil assigns(:curr_user)
    assert_not_nil assigns(:messages)
  end
  
  def test_delete_message
    id = 1
    assert_nothing_raised {
      MessageAlias.find(id)
    }
    post :delete_message, :id => id
    assert_response :redirect
    assert_redirected_to :action => 'list'
    
    # not found
    assert_raise(ActiveRecord::RecordNotFound){
      MessageAlias.find(id)
    }
  end
      
  def test_private_do_send_message
    assert_raise(ActionController::UnknownAction){
      get :do_send_message
    }
  end
  
  def test_private_calculate_message_paging_params
    assert_raise(ActionController::UnknownAction){
      get :calculate_message_paging_params
    }
  end
  
  def test_private_do_paging_messages
    assert_raise(ActionController::UnknownAction){
      get :do_paging_messages
    }
  end
  
  def test_parse_message
    id = 1
    source = "aaaa<b>bbb<c>cc<d>ddd</d>cc</c>bb</b><br/>aaa"

    post :update_message, :id => id, :msg_body => source, :command => 'send'
		
    assert_not_nil assigns(:message)	
    assert_equal "aaaa<b>bbb<c>cc<d>ddd</d>cc</c>bb</b><br/>aaa", assigns["message"].body

    assert_redirected_to :action => 'edit'
  end
end

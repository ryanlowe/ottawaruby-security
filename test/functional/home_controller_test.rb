require File.dirname(__FILE__) + '/../test_helper'

class HomeControllerTest < ActionController::TestCase
  fixtures :users
  
  def test_routing
    assert_routing '/home', :controller => 'home', :action => 'index'
  end
  
  #
  # index
  #
  
  def test_index
    login_as :ryanlowe
    
    get :index
    
    assert_response :success
    assert_template 'index'
  end
  
  def test_index_not_logged_in_not_launched
    launched false
    
    get :index
    
    assert_response :not_found
  end
  
  def test_index_not_logged_in_launched
    launched true
    
    get :index
    
    assert_response :redirect
    assert_redirected_to login_url
  end
  
end

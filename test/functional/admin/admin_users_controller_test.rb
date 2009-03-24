require File.dirname(__FILE__) + '/../../test_helper'

class AdminUsersControllerTest < ActionController::TestCase
  fixtures :users
  
  def test_routing
    assert_routing '/admin/users',   :controller => 'admin_users', :action => 'list'
    assert_routing '/admin/user/45', :controller => 'admin_users', :action => 'show', :id => '45'
  end
  
  #
  # list
  #
  
  def test_list
    login_as :ryanlowe
    assert users(:ryanlowe).admin?
    
    get :list
    
    assert_response :success
    assert_template 'list'
    
    assert_equal User.count, assigns(:users).size
  end
  
  def test_list_not_admin
    login_as :jonny
    assert !users(:jonny).admin?
    
    get :list
    
    assert_response :not_found
  end
  
  def test_list_not_logged_in_not_launched
    launched false
    
    get :list
    
    assert_response :not_found
  end
  
  def test_list_not_logged_in_launched
    launched true
    
    get :list
    
    assert_response :not_found
  end

  #
  # show
  #
  
  def test_show
    login_as :ryanlowe
    assert users(:ryanlowe).admin?
    
    get :show, :id => users(:jonny)
    
    assert_response :success
    assert_template 'show'
    
    assert_equal users(:jonny), assigns(:user)
  end
  
  def test_show_no_id
    login_as :ryanlowe
    assert users(:ryanlowe).admin?
    
    assert_raises(ActiveRecord::RecordNotFound) {
      get :show
    }
  end
  
  def test_show_not_admin
    login_as :jonny
    assert !users(:jonny).admin?
    
    get :show, :id => users(:jonny)
    
    assert_response :not_found
  end
  
  def test_show_not_logged_in_not_launched
    launched false
    
    get :show, :id => users(:jonny)
    
    assert_response :not_found
  end
  
  def test_show_not_logged_in_launched
    launched true
    
    get :show, :id => users(:jonny)
    
    assert_response :not_found
  end
  
end

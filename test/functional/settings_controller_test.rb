require File.dirname(__FILE__) + '/../test_helper'

class SettingsControllerTest < ActionController::TestCase
  fixtures :users, :preference_stores
  
  def test_routing
    assert_routing '/settings/preferences',        :controller => 'settings', :action => 'preferences'
    assert_routing '/settings/update/preferences', :controller => 'settings', :action => 'update_preferences'
    assert_routing '/settings/change/password',    :controller => 'settings', :action => 'change_password'
    assert_routing '/settings/update/password',    :controller => 'settings', :action => 'update_password'
  end
  
  #
  # preferences
  #
  
  def test_preferences_none_yet
    assert_nil users(:jonny).preference_store
    login_as :jonny
    
    get :preferences
    
    assert_response :success
    assert_template 'preferences'
    
    assert_not_nil assigns(:preference_store)
    assert assigns(:preference_store).new_record?
  end
  
  def test_preferences
    assert_not_nil users(:ryanlowe).preference_store
    login_as :ryanlowe
    
    get :preferences
    
    assert_response :success
    assert_template 'preferences'
    
    assert_not_nil assigns(:preference_store)
    assert !assigns(:preference_store).new_record?
  end
  
  def test_preferences_not_logged_in_not_launched
    launched false
    
    get :preferences
    
    assert_response :not_found
  end
  
  def test_preferences_not_logged_in_launched
    launched true
    
    get :preferences
    
    assert_response :redirect
    assert_redirected_to login_url
  end
  
  #
  # update_preferences
  #
  
  def test_update_preferences_none_yet
    assert_nil users(:jonny).preference_store
    login_as :jonny
    
    post :update_preferences, :preference_store => { :notify_new_message => "0" }
    
    assert_response :redirect
    assert_redirected_to :action => 'preferences'
    
    users(:jonny).reload
    assert_not_nil users(:jonny).preference_store
    assert !users(:jonny).preference_store.notify_new_message
  end
  
  def test_update_preferences
    assert_not_nil users(:ryanlowe).preference_store
    assert users(:ryanlowe).preference_store.notify_new_message
    login_as :ryanlowe
    
    post :update_preferences, :preference_store => { :notify_new_message => "0" }
    
    assert_response :redirect
    assert_redirected_to :action => 'preferences'
    
    users(:ryanlowe).reload
    users(:ryanlowe).preference_store.reload
    assert !users(:ryanlowe).preference_store.notify_new_message # changed
  end
  
  def test_update_preferences_get
    assert_not_nil users(:ryanlowe).preference_store
    assert users(:ryanlowe).preference_store.notify_new_message
    login_as :ryanlowe
    
    get :update_preferences, :preference_store => { :notify_new_message => "0" }
    
    assert_response :redirect
    assert_redirected_to front_url
    
    users(:ryanlowe).reload
    users(:ryanlowe).preference_store.reload
    assert users(:ryanlowe).preference_store.notify_new_message # unchanged
  end
  
  def test_update_preferences_not_logged_in_not_launched
    launched false
    
    post :update_preferences
    
    assert_response :not_found
  end
  
  def test_update_preferences_not_logged_in_launched
    launched true
    
    post :update_preferences
    
    assert_response :redirect
    assert_redirected_to login_url
  end
  
  #
  # change_password
  #
  
  def test_change_password
    login_as :ryanlowe

    get :change_password

    assert_response :success
    assert_template 'change_password'
  end

  def test_change_password_not_logged_in_not_launched
    launched false
    
    get :change_password

    assert_response :not_found
  end
  
  def test_change_password_not_logged_in_launched
    launched true
    
    get :change_password

    assert_response :redirect
    assert_redirected_to login_url
  end
  
  #
  # update_password
  #
  
  def test_update_password
    assert_equal users(:ryanlowe), User.authenticate('ryanlowe','test')
    login_as :ryanlowe
    
    post :update_password, :user => { :password => '2test', :password_confirmation => '2test' }
    
    assert_response :redirect
    assert_redirected_to :action => 'change_password'
    
    assert_equal users(:ryanlowe), User.authenticate('ryanlowe','2test')
  end
  
  def test_update_password_get
    assert_equal users(:ryanlowe), User.authenticate('ryanlowe','test')
    login_as :ryanlowe
    
    get :update_password, :user => { :password => '2test', :password_confirmation => '2test' }
    
    assert_response :redirect
    assert_redirected_to front_url
    
    assert_equal users(:ryanlowe), User.authenticate('ryanlowe','test')
  end
  
  def test_update_password_not_matching
    assert_equal users(:ryanlowe), User.authenticate('ryanlowe','test')
    login_as :ryanlowe
    
    post :update_password, :user => { :password => '3test', :password_confirmation => '2test' }
    
    assert_response :redirect
    assert_redirected_to :action => 'change_password'
    
    assert_equal users(:ryanlowe), User.authenticate('ryanlowe','test')
  end
  
  def test_update_password_both_blank
    assert_equal users(:ryanlowe), User.authenticate('ryanlowe','test')
    login_as :ryanlowe
    
    post :update_password, :user => { :password => '', :password_confirmation => '' }
    
    assert_response :redirect
    assert_redirected_to :action => 'change_password'
    
    assert_equal users(:ryanlowe), User.authenticate('ryanlowe','test')
  end
  
  def test_update_password_no_params
    assert_equal users(:ryanlowe), User.authenticate('ryanlowe','test')
    login_as :ryanlowe
    
    post :update_password
    
    assert_response :redirect
    assert_redirected_to :action => 'change_password'
    
    assert_equal users(:ryanlowe), User.authenticate('ryanlowe','test')
  end
  
end

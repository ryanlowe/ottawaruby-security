require File.dirname(__FILE__) + '/../test_helper'

class SiteControllerTest < ActionController::TestCase

  def test_routing
    assert '/boom', :controller => 'site', :action => 'boom'
    assert '',      :controller => 'site', :action => 'front'
    assert '/',     :controller => 'site', :action => 'front'
  end
  
  #
  # boom!
  #
  
  def test_boom
    assert_raises(RuntimeError) {
      get :boom
    }
  end
  
  def test_boom_not_launched
    launched false
    
    assert_raises(RuntimeError) {
      get :boom
    }
  end
  
  #
  # front
  #
  
  def test_front
    get :front
    
    assert_response :success
    assert_template 'front'
  end
  
  def test_front
    launched false
    
    get :front
    
    assert_response :success
    assert_template 'front'
  end

end

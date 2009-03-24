require File.dirname(__FILE__) + '/../test_helper'

class SiteControllerTest < ActionController::TestCase

  def test_routing
    assert '/boom', :controller => 'site', :action => 'boom'
    assert '',      :controller => 'site', :action => 'front'
    assert '/',     :controller => 'site', :action => 'front'
    assert '/implementations', :controller => 'site', :action => 'implementations'
    assert '/sources', :controller => 'site', :action => 'sources'
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
  
  #
  # implementations
  #
  
  def test_implementations
    get :implementations
    
    assert_response :success
    assert_template 'implementations'
  end
  
  def test_implementations
    launched false
    
    get :implementations
    
    assert_response :success
    assert_template 'implementations'
  end
  
  #
  # sources
  #
  
  def test_sources
    get :sources
    
    assert_response :success
    assert_template 'sources'
  end
  
  def test_sources
    launched false
    
    get :sources
    
    assert_response :success
    assert_template 'sources'
  end

end

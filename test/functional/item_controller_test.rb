require File.dirname(__FILE__) + '/../test_helper'

class ItemControllerTest < ActionController::TestCase
  fixtures :users, :items
  
  def test_routing
    assert_routing '/items',        :controller => 'item', :action => 'list'
    assert_routing '/search/items', :controller => 'item', :action => 'search'
    assert_routing '/create/item',  :controller => 'item', :action => 'create'
  end
  
  #
  # list
  #
  
  def test_list
    login_as :ryanlowe
    
    get :list
    
    assert_response :success
    assert_template 'list'
    
    assert_equal 2, assigns(:items).size
  end
  
  #
  # search
  #
  
  def test_search
    login_as :ryanlowe
    
    get :search, :q => 'go'
    
    assert_response :success
    assert_template 'search'
    
    assert_equal 1, assigns(:items).size
    assert_equal [ items(:mango) ], assigns(:items)
  end
  
end

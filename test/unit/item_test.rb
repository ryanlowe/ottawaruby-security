require File.dirname(__FILE__) + '/../test_helper'

class ItemTest < ActiveSupport::TestCase
  fixtures :users, :items
  
  def test_fixtures
    assert items(:test).valid?
    assert items(:mango).valid?
  end
  
end

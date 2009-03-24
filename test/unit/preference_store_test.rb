require 'test_helper'

class PreferenceStoreTest < ActiveSupport::TestCase
  fixtures :users, :preference_stores
  
  def test_fixtures
    assert preference_stores(:ryanlowe).valid?
  end
  
end

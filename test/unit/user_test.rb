require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :users
  
  def test_fixtures
    assert users(:ryanlowe).valid?
    assert users(:jonny).valid?
    
    assert  users(:ryanlowe).admin?
    assert !users(:jonny).admin?
  end

  def test_should_create_user
    assert_difference User, :count do
      user = create_user
      assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
    end
  end

  def test_should_require_username
    assert_no_difference User, :count do
      user = create_user(:username => nil)
      assert user.errors.on(:username)
    end
  end

  def test_should_require_password
    assert_no_difference User, :count do
      user = create_user(:password => nil)
      assert user.errors.on(:password)
    end
  end

  def test_should_require_password_confirmation
    assert_no_difference User, :count do
      user = create_user(:password_confirmation => nil)
      assert user.errors.on(:password_confirmation)
    end
  end

  def test_should_not_require_email
    assert_difference User, :count do
      user = create_user(:email => nil)
      assert_equal 0, user.errors.size
    end
  end

  def test_should_reset_password
    users(:ryanlowe).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal users(:ryanlowe), User.authenticate('ryanlowe', 'new password')
  end

  def test_should_not_rehash_password
    users(:ryanlowe).update_attributes(:username => 'ryanlowe2')
    assert_equal users(:ryanlowe), User.authenticate('ryanlowe2', 'test')
  end

  def test_should_authenticate_user
    assert_equal users(:ryanlowe), User.authenticate('ryanlowe', 'test')
  end

  protected
  
    def create_user(options = {})
      User.create({ :username => 'quire', :email => 'quire@example.com', :password => 'quire', :password_confirmation => 'quire' }.merge(options))
    end
    
end

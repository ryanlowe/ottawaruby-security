require File.dirname(__FILE__) + '/../test_helper'

class MessageTest < ActiveSupport::TestCase
  fixtures :users, :messages
  
  def setup
    @emails = ActionMailer::Base.deliveries
    @emails.clear
  end
  
  def test_fixtures
    assert messages(:ryanlowe2jonny).valid?
    assert messages(:jonny2ryanlowe).valid?
  end
  
  def test_sender_not_valid
    assert !User.exists?(0)
    
    m = Message.new
    m.sent_by = 0
    m.sent_to = users(:ryanlowe).id
    m.body = "Hello!"
    assert !m.valid?
    assert_equal 0, @emails.size
    
    #corrected
    m.sent_by = users(:jonny).id
    assert m.valid?
    assert m.save
    assert_equal 1, @emails.size
  end
  
  def test_recipient_not_valid
    assert !User.exists?(0)
  
    m = Message.new
    m.sent_by = users(:ryanlowe).id
    m.sent_to = 0
    m.body = "Hello!"
    assert !m.valid?
    assert_equal 0, @emails.size
    
    #corrected
    m.sent_to = users(:jonny).id
    assert m.valid?
    assert m.save
    assert_equal 1, @emails.size
  end
  
  def test_in_reply_to_valid
    assert !Message.exists?(0)
  
    m = Message.new
    m.in_reply_to = 0
    m.sent_by = users(:ryanlowe).id
    m.sent_to = users(:jonny).id
    m.body = "Hello!"
    assert !m.valid?
    assert_equal 0, @emails.size
    
    #corrected
    m.in_reply_to = messages(:jonny2ryanlowe).id
    assert m.valid?
    assert m.save
    assert_equal 1, @emails.size
  end
  
  def test_recipient_not_sender
    m = Message.new
    m.sent_by = users(:ryanlowe).id
    m.sent_to = users(:ryanlowe).id
    m.body = "Hello!"
    assert !m.valid?
    assert_equal 0, @emails.size
    
    #corrected
    m.sent_to = users(:jonny).id
    assert m.valid?
    assert m.save
    assert_equal 1, @emails.size
  end
  
  def test_read?
    assert !messages(:jonny2ryanlowe).read?
    messages(:jonny2ryanlowe).read_at = 5.days.ago
    assert messages(:jonny2ryanlowe).save
    messages(:jonny2ryanlowe).reload
    assert messages(:jonny2ryanlowe).read?
  end
  
  def test_deleted?
    assert !messages(:jonny2ryanlowe).deleted?
    messages(:jonny2ryanlowe).deleted_at = 3.days.ago
    assert messages(:jonny2ryanlowe).save
    messages(:jonny2ryanlowe).reload
    assert messages(:jonny2ryanlowe).deleted?
  end
  
  def test_replied?
    assert !messages(:jonny2ryanlowe).replied?
    messages(:jonny2ryanlowe).replied_at = 5.days.ago
    assert messages(:jonny2ryanlowe).save
    messages(:jonny2ryanlowe).reload
    assert messages(:jonny2ryanlowe).replied?
  end
  
  ### SELF
  
  def test_self_reply_subject
    assert_equal "Re:", Message.reply_subject(nil)
    assert_equal "Re:", Message.reply_subject("")
    assert_equal "Re: Hey!", Message.reply_subject("Hey!")
    assert_equal "Re: Hey!", Message.reply_subject("Re: Hey!")
    assert_equal "RE: Hey!", Message.reply_subject("RE: Hey!")
    assert_equal "re: Hey!", Message.reply_subject("re: Hey!")
    assert_equal "Re: re:Hey!", Message.reply_subject("re:Hey!")
  end

end

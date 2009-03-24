require File.dirname(__FILE__) + '/../test_helper'

class MessagesControllerTest < ActionController::TestCase
  fixtures :users, :messages

  def test_routing
    assert_routing '/inbox',                  :controller => 'messages', :action => 'inbox'
    assert_routing '/outbox',                 :controller => 'messages', :action => 'outbox'
    assert_routing '/trash',                  :controller => 'messages', :action => 'trash'
    assert_routing '/incoming/23',            :controller => 'messages', :action => 'incoming',   :id => '23'
    assert_routing '/outgoing/67',            :controller => 'messages', :action => 'outgoing',   :id => '67'
    assert_routing '/send/message/to/5',      :controller => 'messages', :action => 'new',        :id => '5'
    assert_routing '/reply/to/message/41',    :controller => 'messages', :action => 'reply',      :id => '41'
    assert_routing '/create/message/to/5',    :controller => 'messages', :action => 'create',     :id => '5'
    assert_routing '/destroy/incoming/63',    :controller => 'messages', :action => 'destroy',    :id => '63'
    assert_routing '/undestroy/incoming/37',  :controller => 'messages', :action => 'undestroy',  :id => '37'
  end
  
  #
  # inbox
  #
  
  def test_inbox
    login_as :ryanlowe 
  
    get :inbox
    
    assert_response :success
    assert_template 'inbox'
    assert_equal [ messages(:jonny2ryanlowe) ], assigns(:messages)
  end
  
  def test_inbox_not_logged_in_launched
    launched true
    
    get :inbox
    
    assert_response :redirect
    assert_redirected_to login_url
  end
  
  def test_inbox_not_logged_in_not_launched
    launched false
    
    get :inbox
    
    assert_response :not_found
  end
  
  #
  # outbox
  #
  
  def test_outbox
    login_as :ryanlowe 
  
    get :outbox
    
    assert_response :success
    assert_template 'outbox'
    assert_equal [ messages(:ryanlowe2jonny) ], assigns(:messages)
  end
  
  def test_outbox_not_logged_in_launched
    launched true
    
    get :outbox
    
    assert_response :redirect
    assert_redirected_to login_url
  end
  
  def test_outbox_not_logged_in_not_launched
    launched false
    
    get :outbox
    
    assert_response :not_found
  end
  
  #
  # trash
  #
  
  def test_trash
    login_as :ryanlowe 
  
    get :trash
    
    assert_response :success
    assert_template 'trash'
    assert_equal [], assigns(:messages)
  end
  
  def test_trash_not_logged_in_launched
    launched true
    
    get :trash
    
    assert_response :redirect
    assert_redirected_to login_url
  end
  
  def test_trash_not_logged_in_not_launched
    launched false
    
    get :trash
    
    assert_response :not_found
  end
  
  #
  # new
  #
  
  def test_new
    login_as :ryanlowe 
  
    get :new, :id => users(:jonny).id
    
    assert_response :success
    assert_template 'new'
    assert assigns(:message).new_record?
  end
  
  def test_new_bad_id
    login_as :ryanlowe
    assert !User.exists?(0)

    assert_raises(ActiveRecord::RecordNotFound) {
      get :new, :id => 0
    }
  end
  
  def test_new_no_id
    login_as :ryanlowe 
  
    assert_raises(ActiveRecord::RecordNotFound) {
      get :new
    }
  end
  
  def test_new_not_logged_in_launched
    launched true
    
    get :new, :id => users(:jonny).id
    
    assert_response :redirect
    assert_redirected_to login_url
  end
  
  def test_new_not_logged_in_not_launched
    launched false
    
    get :new, :id => users(:jonny).id
    
    assert_response :not_found
  end
  
  #
  # reply
  #
  
  def test_reply
    login_as :ryanlowe 
  
    get :reply, :id => messages(:jonny2ryanlowe)
    
    assert_response :success
    assert_template 'reply'

    assert_equal messages(:jonny2ryanlowe), assigns(:parent)
    assert assigns(:message).new_record?
    assert_equal messages(:jonny2ryanlowe).id, assigns(:message).in_reply_to
    assert_equal "Re: Hey!", messages(:jonny2ryanlowe).subject
    assert_equal messages(:jonny2ryanlowe).subject, assigns(:message).subject
  end
  
  def test_reply_wrong_user
    login_as :jonny 
  
    get :reply, :id => messages(:jonny2ryanlowe)
    
    assert_response :redirect
    assert_redirected_to :action => 'inbox'
  end
  
  def test_reply_bad_id
    login_as :ryanlowe
    assert !Message.exists?(0)

    assert_raises(ActiveRecord::RecordNotFound) {
      get :reply, :id => 0
    }
  end
  
  def test_reply_no_id
    login_as :ryanlowe 
  
    assert_raises(ActiveRecord::RecordNotFound) {
      get :reply
    }
  end
  
  def test_reply_not_logged_in_launched
    launched true
    
    get :reply, :id => messages(:jonny2ryanlowe)
    
    assert_response :redirect
    assert_redirected_to login_url
  end
  
  def test_reply_not_logged_in_not_launched
    launched false
    
    get :reply, :id => messages(:jonny2ryanlowe)
    
    assert_response :not_found
  end
  
  #
  # create
  #
  
  def test_create
# TODO: move @emails setup to an aliased setup method;
# ActionController::TestCase doesn't allow setup to be overriden
    @emails = ActionMailer::Base.deliveries
    @emails.clear
    login_as :ryanlowe 
    message_count = Message.count
  
    post :create, :id => users(:jonny).id, :message => { :body => "Hi!" }
    
    assert_response :redirect
    assert_redirected_to inbox_url
    
    assert_equal message_count+1, Message.count
    message = Message.find(:first, :order => "id DESC")
    assert_equal users(:ryanlowe).id, message.sent_by
    assert_equal users(:jonny).id, message.sent_to
    assert_equal "Hi!", message.body
    assert_equal 1, @emails.size
  end
  
  def test_create_get
    @emails = ActionMailer::Base.deliveries
    @emails.clear
    login_as :ryanlowe 
    message_count = Message.count
  
    get :create, :id => users(:jonny).id, :message => { :body => "Hi!" }
    
    assert_response :redirect
    assert_redirected_to :controller => 'messages', :action => 'inbox'
    
    assert_equal message_count, Message.count
    assert_equal 0, @emails.size
  end
  
  def test_create_error
    @emails = ActionMailer::Base.deliveries
    @emails.clear
    login_as :ryanlowe 
    message_count = Message.count
  
    post :create, :id => users(:jonny).id, :message => { }
    
    assert_response :success
    assert_template 'new'
    assert_equal 0, @emails.size
  end
  
  def test_create_error
    @emails = ActionMailer::Base.deliveries
    @emails.clear
    login_as :ryanlowe 
    message_count = Message.count
  
    assert_raises(ActiveRecord::RecordNotFound) {
      post :create, :message => { :body => "Hello World!" }
    }
    assert_equal 0, @emails.size
  end

  def test_create_reply
    @emails = ActionMailer::Base.deliveries
    @emails.clear
    login_as :ryanlowe 
    message_count = Message.count
  
    post :create, :id => users(:jonny).id, :message => { :in_reply_to => messages(:jonny2ryanlowe).id, :body => "Hi!" }
    
    assert_response :redirect
    assert_redirected_to inbox_url
    
    assert_equal message_count+1, Message.count
    message = Message.find(:first, :order => "id DESC")
    assert_equal users(:ryanlowe).id, message.sent_by
    assert_equal users(:jonny).id, message.sent_to
    assert_equal messages(:jonny2ryanlowe).id, message.in_reply_to
    assert_equal "Hi!", message.body
    assert_equal 1, @emails.size
  end
  
  def test_create_reply_to_anothers_message
    @emails = ActionMailer::Base.deliveries
    @emails.clear
    login_as :ryanlowe 
    message_count = Message.count
  
    post :create, :id => users(:jonny).id, :message => { :in_reply_to => messages(:ryanlowe2jonny).id, :body => "Hi!" }
    
    assert_response :redirect
    assert_redirected_to inbox_url
    
    assert_equal message_count, Message.count
    assert_equal 0, @emails.size
  end
  
  def test_create_not_logged_in_launched
    launched true
    
# TODO: move @emails setup to an aliased setup method;
# ActionController::TestCase doesn't allow setup to be overriden
    @emails = ActionMailer::Base.deliveries
    @emails.clear
    message_count = Message.count

    post :create, :id => users(:jonny).id, :message => { :body => "Hi!" }

    assert_response :redirect
    assert_redirected_to login_url

    assert_equal message_count, Message.count
    assert_equal 0, @emails.size
  end
  
  def test_create_not_logged_in_not_launched
    launched false

# TODO: move @emails setup to an aliased setup method;
# ActionController::TestCase doesn't allow setup to be overriden
    @emails = ActionMailer::Base.deliveries
    @emails.clear
    message_count = Message.count

    post :create, :id => users(:jonny).id, :message => { :body => "Hi!" }

    assert_response :not_found

    assert_equal message_count, Message.count
    assert_equal 0, @emails.size
  end
  
  #
  # destroy
  #
  
  def test_destroy
    login_as :jonny
    message_count = Message.count
    assert !messages(:ryanlowe2jonny).deleted?
    assert_equal [ messages(:ryanlowe2jonny) ], Message.find_inbox(users(:jonny))
    assert_equal [ messages(:ryanlowe2jonny) ], Message.find_outbox(users(:ryanlowe))
    
    post :destroy, :id => messages(:ryanlowe2jonny).id
    
    assert_response :redirect
    assert_redirected_to inbox_url
    
    assert_equal message_count, Message.count
    messages(:ryanlowe2jonny).reload
    assert messages(:ryanlowe2jonny).deleted?
    assert_equal [], Message.find_inbox(users(:jonny))
    assert_equal [ messages(:ryanlowe2jonny) ], Message.find_outbox(users(:ryanlowe))
  end
  
  def test_destroy_get
    login_as :jonny
    message_count = Message.count
    assert !messages(:ryanlowe2jonny).deleted?
    
    get :destroy, :id => messages(:ryanlowe2jonny).id
    
    assert_response :redirect
    assert_redirected_to inbox_url
    
    assert_equal message_count, Message.count
    messages(:ryanlowe2jonny).reload
    assert !messages(:ryanlowe2jonny).deleted?
  end
  
  def test_destroy_anothers_message
    login_as :ryanlowe
    message_count = Message.count
    assert !messages(:ryanlowe2jonny).deleted?
    
    post :destroy, :id => messages(:ryanlowe2jonny).id
    
    assert_response :redirect
    assert_redirected_to inbox_url
    
    assert_equal message_count, Message.count
    messages(:ryanlowe2jonny).reload
    assert !messages(:ryanlowe2jonny).deleted?
  end
  
  def test_destroy_not_logged_in_launched
    launched true
    
    message_count = Message.count
    assert !messages(:ryanlowe2jonny).deleted?
    
    post :destroy, :id => messages(:ryanlowe2jonny).id
    
    assert_response :redirect
    assert_redirected_to login_url
    
    assert_equal message_count, Message.count
    messages(:ryanlowe2jonny).reload
    assert !messages(:ryanlowe2jonny).deleted?
  end
  
  def test_destroy_not_logged_in_not_launched
    launched false
    
    message_count = Message.count
    assert !messages(:ryanlowe2jonny).deleted?
    
    post :destroy, :id => messages(:ryanlowe2jonny).id
    
    assert_response :not_found
    
    assert_equal message_count, Message.count
    messages(:ryanlowe2jonny).reload
    assert !messages(:ryanlowe2jonny).deleted?
  end
  
  #
  # undestroy
  #
  
  def test_undestroy
    login_as :jonny
    message_count = Message.count
    messages(:ryanlowe2jonny).destroy
    messages(:ryanlowe2jonny).reload
    assert messages(:ryanlowe2jonny).deleted?
    assert_equal [], Message.find_inbox(users(:jonny))
    assert_equal [ messages(:ryanlowe2jonny) ], Message.find_outbox(users(:ryanlowe))
    
    post :undestroy, :id => messages(:ryanlowe2jonny).id
    
    assert_response :redirect
    assert_redirected_to inbox_url
    
    assert_equal message_count, Message.count
    messages(:ryanlowe2jonny).reload
    assert !messages(:ryanlowe2jonny).deleted?
    assert_equal [ messages(:ryanlowe2jonny) ], Message.find_inbox(users(:jonny))
    assert_equal [ messages(:ryanlowe2jonny) ], Message.find_outbox(users(:ryanlowe))
  end
  
  def test_undestroy_get
    login_as :jonny
    message_count = Message.count
    messages(:ryanlowe2jonny).destroy
    messages(:ryanlowe2jonny).reload
    assert messages(:ryanlowe2jonny).deleted?
    
    get :undestroy, :id => messages(:ryanlowe2jonny).id
    
    assert_response :redirect
    assert_redirected_to inbox_url
    
    assert_equal message_count, Message.count
    messages(:ryanlowe2jonny).reload
    assert messages(:ryanlowe2jonny).deleted?
  end
  
  def test_undestroy_anothers_message
    login_as :ryanlowe
    message_count = Message.count
    messages(:ryanlowe2jonny).destroy
    messages(:ryanlowe2jonny).reload
    assert messages(:ryanlowe2jonny).deleted?
    
    post :undestroy, :id => messages(:ryanlowe2jonny).id
    
    assert_response :redirect
    assert_redirected_to inbox_url
    
    assert_equal message_count, Message.count
    messages(:ryanlowe2jonny).reload
    assert messages(:ryanlowe2jonny).deleted?
  end
  
  def test_undestroy_not_logged_in_launched
    launched true
    
    message_count = Message.count
    messages(:ryanlowe2jonny).destroy
    messages(:ryanlowe2jonny).reload
    assert messages(:ryanlowe2jonny).deleted?
    
    post :undestroy, :id => messages(:ryanlowe2jonny).id
    
    assert_response :redirect
    assert_redirected_to login_url
    
    assert_equal message_count, Message.count
    messages(:ryanlowe2jonny).reload
    assert messages(:ryanlowe2jonny).deleted?
  end
  
  def test_undestroy_not_logged_in_not_launched
    launched false
    
    message_count = Message.count
    messages(:ryanlowe2jonny).destroy
    messages(:ryanlowe2jonny).reload
    assert messages(:ryanlowe2jonny).deleted?
    
    post :undestroy, :id => messages(:ryanlowe2jonny).id
    
    assert_response :not_found
    
    assert_equal message_count, Message.count
    messages(:ryanlowe2jonny).reload
    assert messages(:ryanlowe2jonny).deleted?
  end
  
  #
  # incoming
  #
  
  def test_incoming
    login_as :ryanlowe
    assert_nil messages(:jonny2ryanlowe).read_at
    
    get :incoming, :id => messages(:jonny2ryanlowe)
    
    assert_response :success
    assert_template 'incoming'
    
    messages(:jonny2ryanlowe).reload
    assert_equal messages(:jonny2ryanlowe), assigns(:message)
    assert_not_nil messages(:jonny2ryanlowe).read_at
  end
  
  def test_incoming_not_sender
    login_as :ryanlowe
    
    get :incoming, :id => messages(:ryanlowe2jonny)
    
    assert_response :redirect
    assert_redirected_to inbox_url
  end
  
  def test_incoming_no_id
    login_as :ryanlowe
    
    assert_raises(ActiveRecord::RecordNotFound) {
      get :incoming
    }
  end

  def test_incoming_not_logged_in_launched
    launched true
    
    get :incoming, :id => messages(:jonny2ryanlowe)
    
    assert_response :redirect
    assert_redirected_to login_url
  end
  
  def test_incoming_not_logged_in_not_launched
    launched false
    
    get :incoming, :id => messages(:jonny2ryanlowe)
    
    assert_response :not_found
  end
  
  #
  # outgoing
  #
  
  def test_outgoing
    login_as :ryanlowe
    
    get :outgoing, :id => messages(:ryanlowe2jonny)
    
    assert_response :success
    assert_template 'outgoing'
    
    assert_equal messages(:ryanlowe2jonny), assigns(:message)
  end
  
  def test_outgoing_not_sender
    login_as :ryanlowe
    
    get :outgoing, :id => messages(:jonny2ryanlowe)
    
    assert_response :redirect
    assert_redirected_to inbox_url
  end
  
  def test_outgoing_no_id
    login_as :ryanlowe
    
    assert_raises(ActiveRecord::RecordNotFound) {
      get :outgoing
    }
  end
  
  def test_outgoing_not_logged_in_launched
    launched true
    
    get :outgoing, :id => messages(:ryanlowe2jonny)
    
    assert_response :redirect
    assert_redirected_to login_url
  end
  
  def test_outgoing_not_logged_in_not_launched
    launched false
    
    get :outgoing, :id => messages(:ryanlowe2jonny)
    
    assert_response :not_found
  end
  
end

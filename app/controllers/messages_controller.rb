class MessagesController < ApplicationController  
  helper :profile 

  before_filter :login_required

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :create, :destroy, :undestroy ],
    :redirect_to => { :controller => 'messages', :action => 'inbox' }

  def inbox
    @messages = Message.find_inbox(current_user.id) 
    @title = "Message Inbox"
  end

  def outbox
    @messages = Message.find_outbox(current_user.id)
    @title = "Message Outbox"
  end
  
  def trash
    @messages = Message.find_trash(current_user.id) 
    @title = "Message Trash"
  end
  
  def incoming
    @message = Message.find(params[:id])
    redirect_to inbox_url and return unless @message.sent_to?(current_user.id)
    @message.mark_as_read
    @title = "Incoming Message"
  end
  
  def outgoing
    @message = Message.find(params[:id])
    redirect_to inbox_url and return unless @message.sent_by?(current_user.id)
    @title = "Outgoing Message"
  end

  def new
    @recipient = User.find(params[:id])
    @message = Message.new
    @title = "Send Message"
  end
  
  def reply
    @parent = Message.find(params[:id])
    redirect_to inbox_url and return unless current_user.id == @parent.sent_to
    @recipient = @parent.sender
    @message = Message.new
    @message.in_reply_to = @parent.id
    @message.subject = Message.reply_subject(@parent.subject)
    @title = "Reply to Message"
  end

  def create
    @recipient = User.find(params[:id])
    @message = Message.new(params[:message])
    unless @message.in_reply_to.nil?
      @parent = Message.find(@message.in_reply_to)
      redirect_to inbox_url and return unless current_user.id == @parent.sent_to
    end
    @message.sent_by = current_user.id
    @message.sent_to = @recipient.id
    if @message.save
      flash[:notice] = "Message sent"
      redirect_to inbox_url
    else
      render :action => 'new'
    end
  end
  
  def destroy
    message = Message.find(params[:id])
    if message.destroyable_by?(current_user)
      message.destroy 
      flash[:notice] = "Message deleted"
    end
    redirect_to inbox_url    
  end
  
  def undestroy
    message = Message.find(params[:id])
    if message.destroyable_by?(current_user)
      message.undestroy
      flash[:notice] = "Message undeleted"
    end
    redirect_to inbox_url    
  end
  
end

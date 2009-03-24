class MessageMailer < ActionMailer::Base

  def new_message(message)
# LATER when we have preferences for notifications
# we can cancel the delivery here:
#    @@perform_deliveries = true
#    @@perform_deliveries = message.recipient.preferences.notify_new_message unless message.recipient.preferences.nil?

    from        NOTIFIER_EMAIL
    headers     'Reply-to' => INFO_EMAIL
    recipients  message.recipient.email
    subject     message.sender.full_name+' sent you a message on '+SITE_NAME
    body        :message => message,
                :inbox => url_for(:host => HOST, :controller => 'messages', :action => 'inbox')
  end

end

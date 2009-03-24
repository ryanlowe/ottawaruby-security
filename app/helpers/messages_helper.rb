module MessagesHelper
  def link_messages
    size = Message.inbox_unread_count(current_user.id)
    text = 'Messages'
    text += " (#{size})" if size > 0
    link_to h(text), inbox_url
  end
end

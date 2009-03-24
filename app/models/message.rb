class Message < ActiveRecord::Base
  validates_length_of :body, :in => 1..1024

  belongs_to :parent,    :class_name => "Message", :foreign_key => 'in_reply_to'
  belongs_to :sender,    :class_name => "User", :foreign_key => 'sent_by'
  belongs_to :recipient, :class_name => "User", :foreign_key => 'sent_to'
  
  validates_existence_of :parent, :allow_nil => true
  validates_existence_of :sender
  validates_existence_of :recipient

  def validate
    errors.add(:sent_to, "cannot be the same as sender") if (self[:sent_by] == self[:sent_to])
  end
  
  def after_create
    MessageMailer.deliver_new_message(self)
  end
  
  def destroyed?
    !self.deleted_at.nil?  
  end
  
  def destroy
    return if destroyed?
    self.deleted_at = Time.now.utc
    raise "Unrecoverable save error" unless self.save
  end
  
  def undestroy
    return unless destroyed?
    self.deleted_at = nil
    raise "Unrecoverable save error" unless self.save
  end
  
  ###
  
  def destroyable_by?(user)
    (self[:sent_to] == user.id)
  end
  
  def sent_by?(user_id)
    (self[:sent_by] == user_id)
  end
  
  def sent_to?(user_id)
    (self[:sent_to] == user_id)
  end
  
  def read?
    !self.read_at.nil?
  end
  
  def mark_as_read
    self.read_at = Time.now.utc
    raise "Unrecoverable error" unless self.save
  end
  
  def deleted?
    !self.deleted_at.nil?
  end
  
  def replied?
    !self.replied_at.nil?
  end
  
  def subject_to_s
    (self[:subject].to_s.length < 1) ? "(No subject)" : self[:subject].to_s
  end
  
  # SELF
  
  def self.reply_subject(subject)
    return "Re:" if subject.nil? or subject.length < 1
    upped = subject.upcase
    return subject if upped =~ /^RE: /
    "Re: "+subject
  end
  
  def self.find_all_sent_to(user_id)
    Message.find_all_by_sent_to(user_id, :conditions => "deleted_at IS NULL", :order => "created_at DESC")
  end
  
  def self.find_all_sent_by(user_id)
    Message.find_all_by_sent_by(user_id, :conditions => "deleted_at IS NULL", :order => "created_at DESC")
  end
  
  def self.find_inbox(user_id)
    Message.find_all_by_sent_to(user_id, :conditions => "deleted_at IS NULL", :order => "created_at DESC")
  end
  
  def self.find_outbox(user_id)
    Message.find_all_by_sent_by(user_id, :order => "created_at DESC")
  end
  
  def self.find_trash(user_id)
    Message.find_all_by_sent_to(user_id, :conditions => "deleted_at IS NOT NULL", :order => "created_at DESC")
  end
  
  def self.inbox_unread_count(user_id)
    Message.find_all_by_sent_to(user_id, :conditions => "read_at IS NULL AND deleted_at IS NULL", :order => "created_at DESC").size
  end

end

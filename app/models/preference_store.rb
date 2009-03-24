class PreferenceStore < ActiveRecord::Base
  validates_uniqueness_of :user_id
  
  belongs_to :user
  validates_existence_of :user
  
  attr_accessible :notify_new_message
end

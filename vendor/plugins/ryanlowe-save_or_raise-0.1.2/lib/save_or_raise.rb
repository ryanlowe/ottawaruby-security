class ActiveRecord::Base
  
  def save_or_raise(raiseable = ActiveRecord::RecordNotSaved)
    raiseable = ActiveRecord::RecordNotSaved if raiseable.nil?
    success = save
    raise raiseable unless success
    success
  end
  
end
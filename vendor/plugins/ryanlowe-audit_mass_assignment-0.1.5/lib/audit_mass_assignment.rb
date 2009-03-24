class AuditMassAssignment
  
  def self.audit(model_class)
    return false if model_class.nil?
    !(model_class.attr_accessible.size == 0)
  end
  
  def self.audit_all
    results = ""
    subclasses = Object.subclasses_of(ActiveRecord::Base)
    subclasses.delete CGI::Session::ActiveRecordStore::Session
    failures = []
    for subclass in subclasses
      pass = AuditMassAssignment.audit(subclass)
      failures << subclass unless pass
      status = pass ? "." : "F"
      results += status
    end
    [ subclasses.size, results, failures ]
  end
  
end
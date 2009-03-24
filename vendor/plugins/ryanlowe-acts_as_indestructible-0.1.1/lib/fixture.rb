class Fixture
  
  #TODO: this is fragile
  def find
    klass = @class_name.is_a?(Class) ? @class_name : Object.const_get(@class_name) rescue nil
    if klass
      if klass.respond_to? :destroyed_condition
        klass.find(self[klass.primary_key], :include_destroyed => true)
      else # bad workaround! before the framework is loaded
        klass.find(self[klass.primary_key])
      end
    else
      raise FixtureClassNotFound, "The class #{@class_name.inspect} was not found."
    end
  end
  
end
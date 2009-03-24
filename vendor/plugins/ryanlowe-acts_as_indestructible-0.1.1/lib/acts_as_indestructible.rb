module ActiveRecord #:nodoc:
  
  class Base
    #TODO: there must be a better place to put this
    alias_method :super_reload, :reload
  end
  
  module Acts #:nodoc:
    module Indestructible #:nodoc:
      
      def self.included(base)
        base.extend(ClassMethods)
        class << base
          alias_method :super_calculate, :calculate
          alias_method :super_exists?,   :exists?
          alias_method :super_find,      :find
        end
      end
      
      module ClassMethods
        
        def acts_as_indestructible(options = {})
          extend ActiveRecord::Acts::Indestructible::SingletonMethods
          include ActiveRecord::Acts::Indestructible::InstanceMethods
        end
        
      end
      
      module SingletonMethods
        
        def destroy_all(user, conditions = nil)
          find(:all, :conditions => conditions).each { |object| object.destroy(user) }
        end
        
        def delete(id)
          raise "Is not allowed"
        end
        
        def delete_all(conditions = nil)
          raise "Is not allowed"
        end
        
        def calculate(operation, column_name, options = {})
          super_calculate(operation, column_name, options_excluding_destroyed(options))
        end
        
        def exists?(id_or_conditions, options = {})
          include_destroyed = options[:include_destroyed]
          if id_or_conditions.is_a?(Hash)
            include_destroyed = id_or_conditions[:include_destroyed]
            id_or_conditions.delete :include_destroyed
          end
          options = {}
          options[:select]            = "#{quoted_table_name}.#{primary_key}"
          options[:conditions]        = expand_id_conditions(id_or_conditions) # private method; possibly fragile
          options[:include_destroyed] = include_destroyed          
          !find(:first, options).nil?
        end
        
        def find(*args)
          options = args.extract_options!
          include_destroyed = options[:include_destroyed]
          return super_find(*args) if include_destroyed # revert to normal behaviour
          options.delete :include_destroyed
          args << options_excluding_destroyed(options)
          super_find(*args)
        end
        
        #protected
        
          # if they are protected class methods they cannot be unit tested? :(
        
          def destroyed_condition
            "#{quoted_table_name}.destroyed_at IS NULL"
          end
        
          def options_excluding_destroyed(options)
            options = Hash.new if options.nil?
            if options.has_key?(:conditions) and !options[:conditions].nil?
              case options[:conditions]
                when Array
                  options[:conditions][0] = destroyed_condition+" AND "+options[:conditions][0]
                when Hash
                  options[:conditions][:destroyed_at] = nil
              else
                options[:conditions] = destroyed_condition+" AND "+options[:conditions]
              end
            else
              options[:conditions] = destroyed_condition
            end
            options
          end
          
      end
      
      module InstanceMethods
        
        def destroyed?
          !self[:destroyed_at].nil?
        end
        
        def destroy(user)
          return if user.nil? or !user.is_a? ActiveRecord::Base # ...more conditions?
          return if destroyed?
          self[:destroyed_at] = Time.now
          self[:destroyed_by] = user.id
          save
        end
        
        def reload(options = nil)
          options = {} if options.nil?
          options[:include_destroyed] = true
          super_reload(options)
        end
        
      end
      
    end
  end
end
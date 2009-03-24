require 'acts_as_indestructible'
require 'fixture'
ActiveRecord::Base.send(:include, ActiveRecord::Acts::Indestructible)
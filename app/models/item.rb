class Item < ActiveRecord::Base
  
  belongs_to :creator, :class_name => "User", :foreign_key => 'created_by'
  validates_existence_of :creator
  
  validates_length_of :name, :minimum => 1
  
  #attr_accessible :name
  
  def self.search_for_name(query)
    like = '%'+query+'%'
    Item.find(:all, :conditions => ["name LIKE ?", like], :order => "id DESC")
  end
  
end

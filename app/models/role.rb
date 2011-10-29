class Role < ActiveRecord::Base
  has_many :stakeholders

  Admin = "Admin"
  PE = "PE"
  APPOPS = "APPOPS"
  
  validates_uniqueness_of :name
  
  has_many :acls, :class_name => 'Stakeholder'
  has_many :users, :through => :acls
  
  def self.[] name
    Role.where(:name => name).first
  end
  
end

class Role < ActiveRecord::Base
  has_many :stakeholders

  Admin = "Admin"
  PE = "PE"
  APPOPS = "APPOPS"
  
  validates_uniqueness_of :name
  
  def self.[] name
    Role.where(:name => name).first
  end
end

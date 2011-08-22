class App < ActiveRecord::Base
  # People
  has_many :stakeholders
  has_many :operators, :through => :stakeholders, :class_name => 'User'
  
  has_many :release_packs
  
  # Machine
  has_many :machines

  has_many :operation_templates
  
  has_many :operations
  
  def to_s
  	send :name
  end

end

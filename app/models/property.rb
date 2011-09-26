class Property < ActiveRecord::Base
  GLOBAL = "GLOBAL"

  belongs_to :resource, :polymorphic => true

  validates_uniqueness_of :name, :scope => [:resource_type,:resource_id]

  scope :global, where(:resource_type => Property::GLOBAL)
  
  def self.pairs
    all.inject({}){|hash,env| hash.update(env.name => env.value) }
  end

end

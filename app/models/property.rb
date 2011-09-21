class Property < ActiveRecord::Base
  belongs_to :resource, :polymorphic => true
  GLOBAL = "GLOBAL"
end

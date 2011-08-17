class Role < ActiveRecord::Base
  has_many :stakeholders
  Admin = 1
  PE = 2
  APPOPS = 3
end

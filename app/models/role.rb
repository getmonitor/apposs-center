class Role < ActiveRecord::Base
  has_many :stakeholders

  Admin = "Admin"
  PE = "PE"
  APPOPS = "APPOPS"
end

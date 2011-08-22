class Stakeholder < ActiveRecord::Base
  belongs_to :user
  belongs_to :app
  belongs_to :role

  validates_uniqueness_of :app_id, :scope => [:user_id, :role_id], :message => "您已经将当前应用分配给了指定的用户与角色"
end

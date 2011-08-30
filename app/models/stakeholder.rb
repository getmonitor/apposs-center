# coding: utf-8
class Stakeholder < ActiveRecord::Base
  belongs_to :user
  belongs_to :app
  belongs_to :role

  validates_uniqueness_of :app_id, :scope => [:user_id, :role_id], :message => "您已将当前应用分配给指定用户和角色了"
end

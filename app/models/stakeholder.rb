# coding: utf-8

# 其实就是一个基于Role 的 ACL 
class Stakeholder < ActiveRecord::Base

  belongs_to :user

  belongs_to :role

  belongs_to :resource, :polymorphic => true
  
  validates_uniqueness_of :role_id, :scope => [:user_id, :resource_id, :resource_type]

end

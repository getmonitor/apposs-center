# coding: utf-8

# 其实就是一个基于Role 的 ACL 
class Stakeholder < ActiveRecord::Base
  belongs_to :user

  belongs_to :role

  belongs_to :resource, :polymorphic => true

end

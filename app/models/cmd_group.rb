class CmdGroup < ActiveRecord::Base
  has_many :cmd_defs, :dependent => :nullify
  
  has_many :app_binds, :class_name => 'AppCmdGroup'
  has_many :apps, :through => :app_binds
  
  attr_accessor :cmd_def_ids
  
  def to_s
  	name
  end
end

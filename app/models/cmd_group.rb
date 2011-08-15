class CmdGroup < ActiveRecord::Base
  has_many :cmd_defs, :dependent => :nullify

  has_many :app_binds, :class_name => 'AppCmdGroup'
  has_many :apps, :through => :app_binds

  attr_accessor :cmd_def_ids

  #def self.search(per_page, page)
  #  cmd_groups = paginate :per_page => per_page.to_i, :page => page.to_i
  #  '{"totalCount":"'+CmdGroup.all.count.to_s + '","cmd_groups":' + cmd_groups.to_json + '}'
  #end

  def to_s
    name
  end
end

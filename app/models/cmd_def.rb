class CmdDef < ActiveRecord::Base
  belongs_to :cmd_group

  has_many :cmd_def_binds
  has_many :cmd_set_defs, :through => :cmd_def_binds

  def self.search(per_page, page, total)
    cmd_defs = paginate :per_page => per_page.to_i, :page => page.to_i
    '{"totalCount":"'+total.to_s + '","cmd_defs":' + cmd_defs.to_json + '}'
  end
end

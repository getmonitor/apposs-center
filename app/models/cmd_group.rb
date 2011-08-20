class CmdGroup < ActiveRecord::Base
  has_many :cmd_defs, :dependent => :nullify

  def to_s
    name
  end
end

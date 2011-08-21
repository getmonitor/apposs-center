class CmdGroup < ActiveRecord::Base
  has_many :directive_templates, :dependent => :nullify

  def to_s
    name
  end
end

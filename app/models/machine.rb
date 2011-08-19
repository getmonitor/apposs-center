class Machine < ActiveRecord::Base
  belongs_to :room
  belongs_to :app

  has_many :operations #, :conditions => ['status <> ?', Operation::COMPLETED]
  has_many :cmd_defs, :through => :operations

  validates_inclusion_of :port,:in => 1..65535,:message => "port必须在1到65535之间"

  def operations_on_current_app
    operations.select do |o|
      o.cmd_set.app == app
    end
  end

end

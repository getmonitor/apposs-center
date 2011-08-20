class Machine < ActiveRecord::Base
  belongs_to :room
  belongs_to :app

  has_many :operations #, :conditions => ['status <> ?', Operation::COMPLETED]

  validates_inclusion_of :port,:in => 1..65535,:message => "port必须在1到65535之间"

end

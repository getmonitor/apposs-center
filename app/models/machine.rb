class Machine < ActiveRecord::Base
  belongs_to :room
  belongs_to :app

  has_many :operations #, :conditions => ['status <> ?', Operation::COMPLETED]
  has_many :commands, :through => :operations

  #def self.search(per_page, page, total, machines)
  #end
end

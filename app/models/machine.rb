class Machine < ActiveRecord::Base
  belongs_to :room
  belongs_to :app

  has_many :operations #, :conditions => ['status <> ?', Operation::COMPLETED]
  has_many :commands, :through => :operations

  def self.search(per_page, page, total, machines)
    machines = machines.paginate :per_page => per_page.to_i, :page => page.to_i
    '{"totalCount":"'+total.to_s + '","machines":' + machines.to_json + '}'
  end
end

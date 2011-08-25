class Machine < ActiveRecord::Base
  belongs_to :room
  belongs_to :app

  has_many :directives #, :conditions => ['status <> ?', Directive::COMPLETED]

  validates_inclusion_of :port,:in => 1..65535,:message => "port必须在1到65535之间"

  def before_save
    if self.host.nil? or host.empty?
      self.host = self.name
    end
  end
end

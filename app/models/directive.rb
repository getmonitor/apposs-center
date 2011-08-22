class Directive < ActiveRecord::Base
  belongs_to :machine
  belongs_to :operation
  default_scope order("id")

  scope :inits, where(:state => :init)

  def callback( isok, body)
    self.isok = isok
    self.response = body
    isok ? ok : error
    #TODO 更新 operation state
    operation.done
  end

  state_machine :state, :initial => :init do
    event :download do transition :init => :ready end
    event :invoke do transition :ready => :running end
    event :error do transition :running => :failure end
    event :ok do transition :running => :done end
    event :ack do transition :failure => :done end
  end

end

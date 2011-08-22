class Directive < ActiveRecord::Base
  belongs_to :machine
  belongs_to :operation
  default_scope order("id")

  scope :inits, where(:state => :init)

  def callback( isok, body)
    self.isok = isok
    self.response = body
    isok ? ok : error
    
  end

  state_machine :state, :initial => :init do
    event :download do transition :init => :ready end
    event :invoke do transition :ready => :running end
    event :error do transition :running => :failure end
    event :ok do transition :running => :done end
    event :ack do transition :failure => :done end

    after_transition :on => :invoke, :do => :fire_operation
    after_transition :on => :error, :do => :error_operation
    after_transition :on => :ok, :do => :check_ok_operation
  end

  def fire_operation
    operation.fire
  end
  
  def error_operation
    operation.error
  end
  
  def check_ok_operation
    if operation.directives.without_state(:done).count == 0
      operation.ok
    end
  end
  
end

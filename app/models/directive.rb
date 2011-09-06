class Directive < ActiveRecord::Base
  belongs_to :machine
  belongs_to :operation
  default_scope order("operation_id asc, id asc")

  scope :normal, where('operation_id <> 0')

  attr_accessor :params

  before_create :params_inline

  def params_inline
    if params && params.is_a?(Hash)
      params.each{|pair| command_name.gsub! %r{\$#{pair[0]}}, pair[1] }
    end
  end

  def callback( isok, body)
    self.isok = isok
    self.response = body
    isok ? ok : error
  end

  state_machine :state, :initial => :init do
    # 需要延迟使用的directive，可以初始化为hold状态
    event :enable do transition :hold => :init end
    # 清理已经无用的未执行directive
    event :clear do transition [:disable, :init, :ready] => :done end
    event :download do transition :init => :ready end
    event :invoke do transition :ready => :running end
    event :error do transition :running => :failure end
    event :ok do transition :running => :done end
    event :ack do transition :failure => :done end

    after_transition :on => :clear, :do => :response_clear
    after_transition :on => :invoke, :do => :fire_operation
    after_transition :on => :error, :do => :error_fire
    after_transition :on => [:ok,:ack], :do => :check_operation
  end

  def response_clear
    update_attribute :response, "be cleared"
  end

  def fire_operation
    operation.fire if has_operation?
  end

  def error_fire
    operation.error if has_operation?
    machine.error
  end
  
  def check_operation
    p 'check ok operation'
    if has_operation? and operation.directives.without_state(:done).count == 0
      operation.ok || operation.ack
    end
  end

  # 对于某些特殊的指令（例如：针对machine的，对应的operation_id 为0
  def has_operation?
    operation_id != Operation::GLOBAL_ID
  end

end

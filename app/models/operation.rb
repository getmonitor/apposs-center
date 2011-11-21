# coding: utf-8

# 运维操作的实例，代表一次运维操作
class Operation < ActiveRecord::Base

  # 使用场景： 1. 某些指令独立执行，没有真实关联的操作对象
  #           2. 机器被重新分配app后，历史指令需要切断与operation之间的联系，以免混乱
  DEFAULT_ID = 0 
  STATE_COULD_BE_CLEAR=['hold','wait','init']

  belongs_to :operation_template

  has_many :directives
  has_many :machines, :through => :directives

  has_one    :next,     :class_name => 'Operation', :foreign_key => 'previous_id'
  belongs_to :previous, :class_name => 'Operation'

  belongs_to :operator, :class_name => 'User'

  belongs_to :app

  attr_accessor :machine_ids

  state_machine :state, :initial => :init do
    # 需要延迟使用的directive，可以初始化为hold状态
    event :enable do transition [:hold,:wait] => :init end
    event :continue do transition :wait => :init end
    event :fire do transition :init => :running end
    event :error do transition [:init,:running] => :failure end
    event :ack do transition :failure => :done end
    event :ok do transition :running => :done end

    before_transition :on => [:enable,:continue], :do => :enable_directive
    after_transition  :on => :ok, :do => :continue_next

  end

  def enable_directive
    Directive.transaction do
      directives.order('id asc').each{|d|
        d.enable
      }
    end
  end

  def continue_next
    self.next.continue unless self.next.nil?
  end
end

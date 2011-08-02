class Operation < ActiveRecord::Base
  belongs_to :machine
  belongs_to :command
  
  default_scope order("id")

  scope :inits, where(:state => :init)

  def callback( isok, body)
    self.isok = isok
    self.response = body
    isok ? ok : error
  end

  state_machine :state, :initial => '已创建' do
    event :download do transition '已创建' => '已下发' end
    event :invoke do transition '已下发' => '执行中' end
    event :error do transition '执行中' => '执行失败' end
    event :ok do transition '执行中' => '结束' end
    event :ack do transition '执行失败' => '结束' end
  end

end

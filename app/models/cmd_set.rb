class CmdSet < ActiveRecord::Base
  belongs_to :cmd_set_def
  
  has_many :commands

  belongs_to :operator, :class_name => 'User'
  
  belongs_to :app

  state_machine :state, :initial => '已创建' do
    event :fire do transition '已创建' => '执行中' end
    event :failure do transition '执行中' => '执行失败' end
    event :acknowledge do transition '执行失败' => '结束' end
    event :ack do transition '执行失败' => '结束' end
    event :success do transition '执行中' => '结束' end
  end
end

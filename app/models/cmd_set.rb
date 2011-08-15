class CmdSet < ActiveRecord::Base
  belongs_to :cmd_set_def

  has_many :operations
  has_many :machines, :through => :operations

  belongs_to :operator, :class_name => 'User'

  belongs_to :app

  state_machine :state, :initial => :init do
    event :fire do transition :init => :running end
    event :error do transition :running => :failure end
    event :ack do transition :failure => :done end
    event :ok do transition :running => :done end
  end
end

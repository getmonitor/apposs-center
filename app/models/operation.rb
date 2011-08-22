class Operation < ActiveRecord::Base
  belongs_to :operation_template

  has_many :directives
  has_many :machines, :through => :directives

  belongs_to :operator, :class_name => 'User'

  belongs_to :app

  state_machine :state, :initial => :init do
    event :fire do transition :init => :running end
    event :error do transition :running => :failure end
    event :ack do transition :failure => :done end
    event :ok do transition :running => :done end
  end
end
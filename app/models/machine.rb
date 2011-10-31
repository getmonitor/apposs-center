# coding: utf-8
class Machine < ActiveRecord::Base
  belongs_to :room
  belongs_to :env

  has_many :directives

  validates_inclusion_of :port,:in => 1..65535,:message => "port必须在1到65535之间"
  validates_presence_of :name

  before_create :fulfill_default

  def fulfill_default
    if self.host.nil? or self.host.empty?
      self.host = self.name
    end
  end

  state_machine :state, :initial => :normal do
    event :error do transition :normal => :pause end
    event :reset do transition :pause => :normal end
  end

  def resume
    reset
    inner_directive 'machine|reset'
  end
  
  def pause
    directive = inner_directive 'machine|pause'
    error
    directive
  end
  
  def interrupt
    directive = inner_directive 'machine|interrupt'
    error
    directive
  end
  
  def clean_all
    directives.without_state(:done).each{|directive|
      directive.clear || directive.force_stop
    }
    inner_directive 'machine|clean_all'
  end
  
  def properties
    env.enable_properties
  end
  
  def inner_directive command
    DirectiveGroup['default'].directive_templates[command].gen_directive(
        :room_id => room.id,
        :room_name => room.name,
        :machine_host => self.host,
        :machine => self
    )
  end
end

# coding: utf-8
class Machine < ActiveRecord::Base

  default_scope where("`machines`.`state` <> 'offline'")
  
  belongs_to :room
  belongs_to :env
  belongs_to :app

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
    event :offline do transition [:normal, :pause] => :offline end
    event :online do transition :offline => :normal end
  end

  def reassign app_id
    transaction do
      self.directives.each do |dd|
        dd.update_attribute :operation_id, Operation::DEFAULT_ID
      end
      self.update_attribute(:app_id, app_id)
    end
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

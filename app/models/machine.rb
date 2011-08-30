# coding: utf-8
class Machine < ActiveRecord::Base
  belongs_to :room
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
  end

  def resume
    reset
    directives.create(
        :operation_id => Operation::GLOBAL_ID,
        :directive_template_id => DirectiveTemplate::GLOBAL_ID,
        :next_when_fail => true,
        :room_id => room_id,
        :room_name => room.name,
        :machine_host => self.host,
        :command_name => "machine|reset"
    )
  end
end

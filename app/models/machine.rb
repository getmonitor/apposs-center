class Machine < ActiveRecord::Base
  belongs_to :room
  belongs_to :app

  has_many :operations #, :conditions => ['status <> ?', Operation::COMPLETED]
  has_many :commands, :through => :operations

  class << self
    def command_state(current_app, machine_id, cmd_set_id)
      if cmd_set_id
        current_app.cmd_sets.where(:id => cmd_set_id).first.commands.inject([]) do |operations, c|
          operations << c.operations.where(:machine_id => machine_id).first
        end.collect do |o|
          o.attributes.update(
              "id" => "#{cmd_set_id}|#{o.id}",
              "leaf" => true,
              "state" => o.human_state_name,
              "name" => o.command_name
          )
        end
      else
        current_app.cmd_sets.select do |cs|
          Machine.find(machine_id).commands.where(:cmd_set_id => cs.id).length > 0
        end.collect do |cs|
          cs.attributes.update "state" => cs.human_state_name
        end
      end
    end
  end
end

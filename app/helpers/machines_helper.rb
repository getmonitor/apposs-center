# coding: utf-8
module MachinesHelper
  def show_state machine
    normal = (machine.state == 'normal')
    raw %Q|
    <span style='color:#{normal ? :green : :red}'>
    #{machine.human_state_name}
    </span>
    #{machine_actions machine, normal}
    |
  end
  
  def machine_actions machine, normal
    actions = []
    actions << link_to('查看指令', directives_machine_path(machine.id), :remote => true )
    actions << link_to('继续', reset_machine_path(machine.id), :remote => true, :method => :put) unless normal
    actions.join "\n"
  end
end


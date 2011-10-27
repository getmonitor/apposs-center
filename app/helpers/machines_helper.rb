# coding: utf-8
module MachinesHelper
  def show_state machine
    normal = (machine.state == 'normal')
    raw %Q|
    <span style="float:right">
      #{machine_actions machine, normal}
    </span>
    <span style="padding:0 4px;float:right;color:#{normal ? :green : :red}">
      #{machine.human_state_name}
    </span>
    |
  end
  
  def machine_actions machine, normal
    actions = []
    actions << link_to('当前指令', directives_machine_path(machine.id), :remote => true )
    actions << link_to('继续', reset_machine_path(machine.id), :remote => true, :method => :put) unless normal
    actions.join "\n"
  end
end


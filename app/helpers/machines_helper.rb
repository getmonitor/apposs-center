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
    actions << link_to('显示指令', directives_machine_path(machine.id), :remote => true )
    if normal
    actions << link_to('暂停', pause_machine_path(machine.id), :remote => true, :method => :put)
    actions << link_to('强制暂停', interrupt_machine_path(machine.id), :remote => true, :method => :put, :confirm => "确实要强制暂停吗？")
    else
      actions << link_to('继续', reset_machine_path(machine.id), :remote => true, :method => :put)
    end
    actions << link_to('清除指令', clean_all_machine_path(machine.id), :remote => true, :method => :put, :confirm => "确实要清除吗？")
    actions.join "\n"
  end
end


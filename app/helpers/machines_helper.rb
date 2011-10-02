# coding: utf-8
module MachinesHelper
  def show_state machine
    color = machine.state == 'normal' ? 'green' : 'red'
    raw "<span style='color:#{color}'>#{machine.human_state_name}</span>"
  end
end



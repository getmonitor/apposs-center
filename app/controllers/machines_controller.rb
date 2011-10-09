class MachinesController < ResourceController

  def reset
    @directive = Machine.find(params[:id]).resume
  end
  
  def directives
    @directives = Machine.find(params[:id]).directives.without_state(:done)
  end
end

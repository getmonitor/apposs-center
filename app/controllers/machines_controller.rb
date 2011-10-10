class MachinesController < ResourceController

  def reset
    @directive = Machine.find(params[:id]).resume
  end
  
  def directives
    @directives = Machine.find(params[:id]).directives.without_state(:done)
  end
  
  def old_directives
    @directives = Machine.find(params[:id]).directives.where(:state => :done)
  end
end

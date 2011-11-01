class MachinesController < ResourceController

  def reset
    @machine = Machine.find(params[:id])
    @directive = @machine.resume
  end
  
  def clean_all
    @machine = Machine.find(params[:id])
    @directive = @machine.clean_all
  end
  
  def interrupt
    @machine = Machine.find(params[:id])
    @directive = @machine.interrupt
  end
  
  def pause
    @machine = Machine.find(params[:id])
    @directive = @machine.pause
  end
  
  def directives
    @directives = Machine.find(params[:id]).directives.without_state(:done)
  end
  
  def old_directives
    @directives = Machine.find(params[:id]).directives.where(:state => :done)
  end
end

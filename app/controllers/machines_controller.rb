class MachinesController < ResourceController

  def reset
    @directive = Machine.find(params[:id]).resume
  end
  
  def clean_all
    @directive = Machine.find(params[:id]).clean_all
  end
  
  def interrupt
    @directive = Machine.find(params[:id]).interrupt
  end
  
  def pause
    @directive = Machine.find(params[:id]).pause
  end
  
  def directives
    @directives = Machine.find(params[:id]).directives.without_state(:done)
  end
  
  def old_directives
    @directives = Machine.find(params[:id]).directives.where(:state => :done)
  end
end

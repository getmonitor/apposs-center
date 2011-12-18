class MachinesController < ResourceController

  def change_env
    @machine = Machine.find(params[:id])
    env_obj = @machine.app.envs.find params['single_form']['env_id']
    @machine.update_attribute :env, env_obj
  end
  
  def reset
    @machine = Machine.find(params[:id])
    @directive = @machine.send_reset
  end
  
  def clean_all
    @machine = Machine.find(params[:id])
    @directive = @machine.send_clean_all
  end
  
  def interrupt
    @machine = Machine.find(params[:id])
    @directive = @machine.send_interrupt
  end
  
  def pause
    @machine = Machine.find(params[:id])
    @directive = @machine.send_pause
  end
  
  def reconnect
    @machine = Machine.find(params[:id])
    @directive = @machine.send_reconnect
  end
  
  def directives
    @directives = Machine.find(params[:id]).directives.without_state(:done)
  end
  
  def old_directives
    @directives = Machine.find(params[:id]).directives.where(:state => :done)
  end
end

class CmdSetsController < BaseController
  def index
    respond_with current_app.cmd_sets
  end
  
  def create
    @cmd_set = current_app.cmd_set_defs.find(params[:cmd_set_def_id]).create_cmd_set_by(current_user)
    @cmd_set = current_app.cmd_sets.create( :cmd_set_def_id => params[:cmd_set_def_id], :operator => current_user )
    
    respond_with @cmd_set
  end
end

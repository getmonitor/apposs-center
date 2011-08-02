class CmdSetsController < BaseController
  def index

    cmd_set_id, command_id = params[:key].split /\|/ if params[:key] != 'root'
    if command_id
      result = current_app.cmd_sets.find(cmd_set_id).commands.find(command_id).operations.collect { |o|
        o.attributes.update "id" => "#{cmd_set_id}|#{command_id}|#{o.id}", "leaf" => "true", "name" => "#{o.command_name}"
      }
      puts result.to_json
      respond_with result
    elsif cmd_set_id
      result = current_app.cmd_sets.find(cmd_set_id).commands.collect { |c|
        c.attributes.update "id" => "#{cmd_set_id}|#{c.id}"
      }
      puts result.to_json
      respond_with result
    else
      respond_with current_app.cmd_sets
    end

#  cmd_set_id, command_id = params[:key].split /\|/ if params[:key] && params[:key] != "root"
#  respond_with if command_id
#  current_app.cmd_sets.find(cmd_set_id).commands.find(command_id).operations
#else
#  if cmd_set_id
#    current_app.cmd_sets.find(cmd_set_id).commands
#  else
#    current_app.cmd_sets
#  end
  end

  def create
    cmd_set = current_app.cmd_set_defs.find(params[:cmd_set_def_id]).create_cmd_set(current_user)
    render :text => cmd_set.to_json
  end

  def show
    render :json => current_app.cmd_sets.find(params[:id]).to_json(:include => [:commands])
  end

end

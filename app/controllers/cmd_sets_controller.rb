class CmdSetsController < BaseController
  def index
    cmd_set_id, machine_id = params[:key].split /\|/ if params[:key] != 'root'
    if machine_id
      result = Machine.find(machine_id).commands.where(:cmd_set_id => cmd_set_id).collect { |c|
        c.attributes.update(
          "id" => "#{cmd_set_id}|#{machine_id}|#{c.id}",
          "leaf" => "true",
          "state" => o.human_state_name
        )
      }
      respond_with result
    elsif cmd_set_id
      result = current_app.machines.collect { |m|
        m.attributes.update "id" => "#{cmd_set_id}|#{m.id}"
      }
      respond_with result
    else
      respond_with current_app.cmd_sets.collect{|cs| 
        cs.attributes.update "state" => cs.human_state_name
      }
    end
  end

  def create
    cmd_set = current_app.cmd_set_defs.find(params[:cmd_set_def_id]).create_cmd_set(current_user)
    render :text => "命令包已创建" #cmd_set.to_json
  end

end

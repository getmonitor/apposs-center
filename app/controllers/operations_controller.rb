class OperationsController < BaseController
  def index
    operation_id, machine_id = params[:key].split /\|/ if params[:key] != 'root'
    if machine_id
      result = Machine.find(machine_id).directives.where(:operation_id => operation_id).collect { |o|
        o.attributes.update(
            "id" => "#{operation_id}|#{machine_id}|#{o.id}",
            "leaf" => "true",
            "state" => o.human_state_name,
            "name" => o.command_name
        )
      }
      respond_with result
    elsif operation_id
      result = current_app.operations.find(operation_id).machines.uniq.collect { |m|
        m.attributes.update(
            "id" => "#{operation_id}|#{m.id}"
        )
      }
      respond_with result
    else
      respond_with current_app.operations.collect { |cs|
        cs.attributes.update "state" => cs.human_state_name
      }
    end
  end

  def create
    # TODO choosddMachinIds.size < 10
    if params[:choosedMachines]
      choosedMachineIds = params[:choosedMachines].split(',').collect{|s| s.to_i}.uniq
    end
    current_app.operation_templates.find(params[:operation_template_id]).create_operation(current_user, choosedMachineIds)
    render :text => "操作已创建"
  end

end

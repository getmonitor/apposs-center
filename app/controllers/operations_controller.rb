class OperationsController < BaseController
  def index
    respond_with current_app.operations.collect { |cs|
      cs.attributes.update(
          "state" => cs.human_state_name,
          "children" => cs.machines.uniq.collect { |m|
            m.attributes.update(
                "id" => "#{cs.id}|#{m.id}",
                "children" => m.directives.where(:operation_id => cs.id).collect { |o|
                  o.attributes.update(
                      "id" => "#{cs.id}|#{m.id}|#{o.id}",
                      "leaf" => "true",
                      "state" => o.human_state_name,
                      "name" => o.command_name
                  )
                }
            )
          }
      )
    }
  end

  def create
    # TODO choosddMachinIds.size < 10
    if params[:choosedMachines]
      choosedMachineIds = params[:choosedMachines].split(',').collect { |s| s.to_i }.uniq
    end
    current_app.operation_templates.find(params[:operation_template_id]).create_operation(current_user, choosedMachineIds)
    render :text => "操作已创建"
  end

end

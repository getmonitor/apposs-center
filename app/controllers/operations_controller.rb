class OperationsController < BaseController
  def index
    respond_with current_app.operations.without_state(:done).collect { |cs|
      cs.attributes.update(
          "state" => cs.human_state_name,
          "children" => cs.machines.uniq.collect { |m|
            m.attributes.update(
                "id" => "#{cs.id}|#{m.id}",
                "state" => "",
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
    if params[:choosedMachines]
      choosed_machine_ids = params[:choosedMachines].split(',').collect { |s| s.to_i }.uniq
    end
    current_app.operation_templates.find(params[:operation_template_id]).create_operation(current_user, choosed_machine_ids)
    render :text => "操作已创建"
  end

end

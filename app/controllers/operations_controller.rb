# coding: utf-8
class OperationsController < ResourceController

  # TODO deprecated
  def create
    if params[:choosedMachines]
      choosed_machine_ids = params[:choosedMachines].split(',').collect { |s| s.to_i }.uniq
    end
    current_app.operation_templates.find(params[:operation_template_id]).gen_operation(current_user, choosed_machine_ids)
    render :text => "操作已创建"
  end

end

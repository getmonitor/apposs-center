# coding: utf-8
class OperationsController < ResourceController
  def enable
    Operation.find(params[:id]).enable
  end

  def clear
    @operation = Operation.find(params[:id])
    @result = @operation.clear
  end

  # TODO deprecated
  def create
    if params[:choosedMachines]
      choosed_machine_ids = params[:choosedMachines].split(',').collect { |s| s.to_i }.uniq
    end
    current_app.operation_templates.find(params[:operation_template_id]).gen_operation(current_user, choosed_machine_ids)
    render :text => "操作已创建"
  end

end

# coding: utf-8
class OperationTemplatesController < ResourceController

  # 创建一个操作实例
  def execute
    if params[:choosedMachines]
      choosed_machine_ids = params[:choosedMachines].split(',').collect { |s| s.to_i }.uniq
    end
    current_app.operation_templates.find(params[:id]).gen_operation(current_user, choosed_machine_ids)
  end


  # 分组创建操作实例
  def group_execute
    if params[:group_count] && params[:group_count].to_i > 0
      group_count = params[:group_count].to_i
    else
      group_count = 1
    end

    all_ids = current_app.machine_ids
    operation_template = current_app.operation_templates.find(params[:id])

    previous_id = nil
    ss = group( all_ids, group_count )
    operations = ss.collect{|id_group|
      operation_on_bottom = operation_template.gen_operation(current_user, id_group, previous_id, params[:is_hold]=="true" )
      previous_id = operation_on_bottom.id
      operation_on_bottom
    }
    operations.first.enable
    render :text => "分组已创建"
  end

  private
  def group arr, group_count
    group_length = arr.size / group_count
    groups = []
    arr.each_with_index{|e,i|
      groups << [] if ((i % group_length) ==0 && i < (group_length * group_count))
      groups.last << e
    }
    groups
  end

end

# coding: utf-8
class OperationTemplatesController < ResourceController

  # 创建一个操作实例
  def execute
    @choosed_machine_ids = check_machine_ids(params[:machine_ids])
    if @choosed_machine_ids.size > 0
      @operation = current_app.
        operation_templates.
          find(params[:id]).
            gen_operation(current_user, @choosed_machine_ids)
    end
  end

  def group_form
    
  end

  # 分组创建操作实例
  def group_execute
    group = params[:group]
    if group[:group_count] && group[:group_count].to_i > 0
      group_count = group[:group_count].to_i
      operation_template = current_app.operation_templates.find(params[:id])
      all_ids = operation_template.available_machine_ids

      previous_id = nil
      ss = group( all_ids, group_count )
      @operations = ss.collect{|id_group|
        operation_on_bottom = operation_template.gen_operation(current_user, id_group, previous_id, group[:is_hold]=="true" )
        previous_id = operation_on_bottom.id
        operation_on_bottom
      }
      @operations.first.enable
    else
      @errmsg = '分组数应当是数字'
    end

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

  def check_machine_ids machine_ids
    (machine_ids||[]).collect { |s| s.to_i }.uniq
  end
end

class OperationTemplatesController < BaseController
  def index
    app_id = params[:app_id]
    role_id = Stakeholder.where(:app_id => app_id, :user_id => current_user.id).first.role_id
    role = Role.find(role_id).name
    operation_templates = current_app.operation_templates
    if role == Role::Admin || role == Role::PE
      if operation_templates.length == 0
        respond_with [{"add" => true}]
      else
        respond_with operation_templates.collect { |obj|
          obj.serializable_hash.update("actions" => [
              {:name=>"准备执行", :flex => 1.7, :url=> app_operations_path(app_id), :type => 'simple', :method => 'POST'},
              {:name=>"修改", :flex => 1, :url=> edit_app_operation_template_path(app_id, obj.id), :type => 'multi', :method => 'GET'},
              {:name=>"删除", :flex => 1, :url=> app_operation_template_path(app_id, obj.id), :type => 'delete', :method => 'DELETE'}
          ], "flex" => 8, "add" => true)
        }
      end
    else
      respond_with current_app.operation_templates.collect { |obj|
        obj.serializable_hash.update("actions" => [
            {:name=>"准备执行", :flex => 1, :url=> app_operations_path(app_id), :type => 'simple', :method => 'POST'}
        ], "flex" => 5, "add" => false)
      }
    end
  end

  def show
    @operation_template = current_app.operation_templates.find(params[:id])
    render
  end

  def edit
    @operation_template = current_app.operation_templates.find(params[:id])
    render
  end

  def create
    respond_with current_app.operation_templates.create(params[:operation_template])
  end

  def update
    respond_with current_app.operation_templates.find(params[:id]).update_attributes params[:operation_template]
  end

  def destroy
    respond_with current_app.operation_templates.find(params[:id]).delete
  end
end

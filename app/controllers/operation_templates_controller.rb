class OperationTemplatesController < BaseController
  def index
    app_id = params[:app_id]
    roles = Stakeholder.where(:app_id => app_id, :user_id => current_user.id).inject([]) do |roles, stakeholder|
      roles << Role.find(stakeholder.role_id).name
    end
    role = roles.index(Role::Admin) ? Role::Admin : (roles.index(Role::PE) ? Role::PE : Role::APPOPS)
    operation_templates = current_app.operation_templates
    if role == Role::Admin || role == Role::PE
      if operation_templates.length == 0
        respond_with [{"add" => true}]
      else
        respond_with operation_templates.collect { |obj|
          obj.serializable_hash.update("actions" => [
              {:name=>"准备执行", :flex => 2.0, :url=> app_operations_path(app_id), :type => 'simple', :method => 'POST'},
              {:name=>"分组执行", :flex => 2.0, :url => app_operations_path(app_id), :type => 'group', :method => 'POST'},
              {:name=>"修改", :flex => 1.2, :url=> edit_app_operation_template_path(app_id, obj.id), :type => 'multi', :method => 'GET'},
              {:name=>"删除", :flex => 1.2, :url=> app_operation_template_path(app_id, obj.id), :type => 'delete', :method => 'DELETE'}
          ], "flex" => 8, "add" => true)
        }
      end
    else
      respond_with current_app.operation_templates.collect { |obj|
        obj.serializable_hash.update("actions" => [
            {:name=>"准备执行", :flex => 1, :url=> app_operations_path(app_id), :type => 'simple', :method => 'POST'},
            {:name=>"分组执行", :flex => 1, :url => app_operations_path(app_id), :type => 'group', :method => 'POST'}
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
    operation_template = current_app.operation_templates.create(params[:operation_template])
    render :text => {"errors" => operation_template.errors}.to_json
  end

  def update
    operation_template = current_app.operation_templates.find(params[:id])
    operation_template.update_attributes params[:operation_template]
    render :text => {"errors" => operation_template.errors}.to_json
  end

  def destroy
    respond_with current_app.operation_templates.find(params[:id]).delete
  end

  def group_execute
    render :text => "分组已创建"
  end
end

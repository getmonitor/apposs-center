class CmdSetDefsController < BaseController
  def index
    app_id = params[:app_id]
    respond_with current_app.cmd_set_defs.collect { |obj|
      obj.serializable_hash.update("actions" => [
          {:name=>"准备执行", :flex => 1.7, :url=> app_cmd_sets_path(app_id), :type => 'simple', :method => 'POST'},
          {:name=>"修改", :flex => 1, :url=> edit_app_cmd_set_def_path(app_id, obj.id), :type => 'multi', :method => 'GET'},
          {:name=>"删除", :flex => 1, :url=> app_cmd_set_def_path(app_id, obj.id), :type => 'delete', :method => 'DELETE'}
      ],"flex" => 8)
    }
  end

  def show
    @cmd_set_def = current_app.cmd_set_defs.find(params[:id])
    render
  end

  def edit
    @cmd_set_def = current_app.cmd_set_defs.find(params[:id])
    render
  end

  def create
    respond_with current_app.cmd_set_defs.create(params[:cmd_set_def])
  end

  def update
    respond_with current_app.cmd_set_defs.find(params[:id]).update_attributes params[:cmd_set_def]
  end

  def destroy
    respond_with current_app.cmd_set_defs.find(params[:id]).delete
  end
end

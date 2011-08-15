class Admin::CmdDefsController < Admin::BaseController
  def index
    cmd_defs = CmdDef.paginate(:per_page => params[:limit].to_i, :page => params[:page].to_i)
    total = cmd_defs.count
    respond_with :totalCount => total, :cmd_defs => cmd_defs
  end

  def show
    respond_with CmdDef.find(params[:id])
  end

  def create
    cmd_def = CmdDef.create(params[:cmd_def])
    render :text => cmd_def.to_json
  end

  def update
    respond_with CmdDef.find(params[:id]).update_attributes(params[:cmd_def])
  end

  def destroy
    respond_with CmdDef.find(params[:id]).delete
  end
end
